import cocotb
from cocotb.triggers import Timer, RisingEdge, FallingEdge, ReadOnly
from cocotb.clock import Clock
from cocotb.utils import get_sim_time
from random import randint 
passed_tests=0
failed_tests = 0

count=0;

# Decorator indicating that this is a cocotb test
@cocotb.test()
async def alu_test(dut):
    """
    Main test function for the ALU.
    
    This function sets up the clock, starts the stimuli driving process,
    and waits for a specified amount of time before ending the test.
    """
    
    global passed_tests, failed_tests
    # Log the start of the test at time 0 ns
    cocotb.log.info(f"@{get_sim_time(units='ns')} ns:---- Start of test! ----")
    
    # Create and start a clock on the dut's clk signal with a period of 10 ns
    CLK = Clock(dut.clk, 10, units='ns')
    await cocotb.start(CLK.start())
    
    # Start the driving stimuli coroutine to generate inputs for the DUT
    await cocotb.start(driving_stimulis(dut))    

    # Wait for 100 ns to allow all stimuli and DUT interactions to complete
    await Timer(12000, units='ns')
    
    # Log the end of the test
    cocotb.log.info(f"@{get_sim_time(units='ns')} ns:---- End of test! ----")
    cocotb.log.info(f"@{get_sim_time(units='ns')} ns:Total passed tests: {passed_tests}")
    cocotb.log.info(f"@{get_sim_time(units='ns')} ns:Total failed tests: {failed_tests}")


async def driving_stimulis(dut):
    """
    Coroutine to drive stimuli to the DUT (Device Under Test).
    """

    cocotb.log.info(f"@{get_sim_time(units='ns')} ns:Starting directed testing ")

    await cocotb.start(driving_directed(dut))  
    cocotb.log.info(f"@{get_sim_time(units='ns')} ns:Ending directed testing ")

    # Wait for 100 ns to allow all stimuli and DUT interactions to complete
    await Timer(120, units='ns')  

    cocotb.log.info(f"@{get_sim_time(units='ns')} ns:Starting random testing ")
    await cocotb.start(driving_random(dut))  
    cocotb.log.info(f"@{get_sim_time(units='ns')} ns:Ending random testing ")


async def driving_directed(dut):
    global count
    # Reset DUT
    count+=1
    cocotb.log.info(f"@{get_sim_time(units='ns')} ns: Performing DUT Reset")
    dut.reset_n.value = 1  # Set reset to high (inactive)
    await FallingEdge(dut.clk)  # Wait for falling edge of clock
    dut.reset_n.value = 0  # Set reset to low (active)
    await cocotb.start(golden_model(dut, 0)) 

    # List of test cases: (op_code, A, B, description)
    tests = [
        (0b00, 0b0101, 0b0011, "OR Operation"),          # OR operation
        (0b01, 0b0101, 0b0011, "AND Operation"),         # AND operation
        (0b10, 0b0101, 0b0001, "Addition Operation"),    # Addition
        (0b11, 0b0111, 0b0001, "Subtraction Operation"), # Subtraction
        (0b10, 0b0111, 0b0111, "Addition with Overflow"),# Addition with overflow
        (0b11, 0b1000, 0b0111, "Subtraction with Overflow") # Subtraction with overflow
    ]
    
    # Iterate over the test cases
    for  i,(op_code, A, B, description) in enumerate(tests,start=1):
        count+=1
        cocotb.log.info(f"@{get_sim_time(units='ns')} ns: Starting test {count} - {description}")
        await FallingEdge(dut.clk)  # Wait for falling edge of clock
        dut.reset_n.value = 1  # Set reset back to high after reset is done
        # Apply stimulus
        dut.op_code.value = op_code  # Set the operation code
        dut.A.value = A  # Set input A
        dut.B.value = B  # Set input B
        # Start the golden model to validate the results
        await cocotb.start(golden_model(dut, count))  # Start golden model comparison




async def driving_random(dut):
    global count
    count = 0  # Initialize count if not already done

    # Iterate over the test cases
    for _ in range(1100):
        count += 1
        cocotb.log.info(f"@{get_sim_time(units='ns')} ns: Starting test {count} - random")

        # Generate random inputs and convert them to integers
        A = randint(0, 15)
        B = randint(0, 15)
        op_code = randint(0, 3)

        await FallingEdge(dut.clk)  # Wait for falling edge of clock
        dut.reset_n.value = 1  # Set reset back to high after reset is done

        # Apply stimulus
        dut.op_code.value = op_code  # Set the operation code
        dut.A.value = A  # Set input A
        dut.B.value = B  # Set input B

        # Start the golden model to validate the results
        await cocotb.start(golden_model(dut, count))  # Start golden model comparison




async def golden_model(dut, count):
    """
    Golden model to check the expected behavior of the DUT.

    Args:
        dut: Device under test.
        count: Test count for logging purposes.
    """
    
    await RisingEdge(dut.clk)
    await ReadOnly()

    # Determine expected values based on the inputs
    if dut.reset_n.value == 0:
        expected_C = decmail_2_two_complement(0 ,4)
        expected_overflow = 0

    else:
        A = dut.A.value
        B = dut.B.value
        A_dec=int(convert_two_complement2decmail(str(A), 4))
        B_dec=int(convert_two_complement2decmail(str(B), 4))

        if dut.op_code.value == 0b00:
            expected_C = decmail_2_two_complement(A |B ,4)
            expected_overflow = 0

        elif dut.op_code.value == 0b01:
            expected_C = decmail_2_two_complement(A &B ,4)
            expected_overflow = 0

        elif dut.op_code.value == 0b10:  # Addition operation
            expected_C =decmail_2_two_complement(A_dec + B_dec,5)[1:5]

            expected_overflow = detect_overflow(A, B, expected_C, addition=True)

        elif dut.op_code.value == 0b11:  # Subtraction operation
            expected_C = decmail_2_two_complement(A_dec - B_dec,5)[1:5]
            
            expected_overflow = detect_overflow(A, B, expected_C, addition=False)

    # # Format the expected_C as 4-bit binary
    # expected_C = format(expected_C, "04b")
    expected_overflow = format(expected_overflow, "01b")

    # Compare the DUT outputs with the expected values
    await compare_outputs(dut, expected_C, expected_overflow, count)


def detect_overflow(A, B, result, addition=True):
    """
    Helper function to detect overflow based on the operation.

    Args:
        A (int): Operand A (assumed to be a 4-bit signed integer).
        B (int): Operand B (assumed to be a 4-bit signed integer).
        result (int): Result of the operation (should also be 4-bit).
        addition (bool): True if addition, False if subtraction.

    Returns:
        bool: True if overflow occurred, else False.
    """
    # Convert to signed 4-bit numbers
    A_sign = int(str(A)[0])  # Extract the sign bit of A
    B_sign = int(str(B)[0])   # Extract the sign bit of B
    result_sign = int(result[0])  # Extract the sign bit of the result
    if addition:
        return (A_sign == B_sign) and (A_sign != result_sign)
    else:
        return (A_sign != B_sign) and (A_sign != result_sign)

async def compare_outputs(dut, expected_C, expected_overflow, count):
    """
    Helper function to compare DUT output with expected values.

    Args:
        dut: Device under test.
        expected_C (str): Expected output value for C.
        expected_overflow (str): Expected overflow value.
        count (int): Test count for logging purposes.
    """
    global passed_tests, failed_tests

    if (str(dut.C.value) == str(expected_C)) and (str(dut.overflow.value) == str(expected_overflow)):
        passed_tests += 1
        cocotb.log.info(f"@{get_sim_time(units='ns')} ns: Test passed_{count}: "
                        f"reset_n={dut.reset_n.value}, A={dut.A.value}, B={dut.B.value}, "
                        f"C={dut.C.value}, Overflow={dut.overflow.value}, OpCode={dut.op_code.value}")
    else:
        failed_tests += 1
        cocotb.log.info(f"@{get_sim_time(units='ns')} ns: Test failed_{count}: "
                        f"reset_n={dut.reset_n.value}, A={dut.A.value}, B={dut.B.value}, "
                        f"C={dut.C.value}, Overflow={dut.overflow.value}, OpCode={dut.op_code.value}, "
                        f"Expected C={expected_C}, Expected Overflow={expected_overflow}")



def decmail_2_two_complement(number, places_int=5):
    '''

    :param number: it the float number to convert it to binary
    :param places_int: number of integer bits to represent int(number) in it
    :return: binary representation of number consist of  (places_int+places_float)bit
    '''
    sign = 0
    number = float(number)
    if number < 0:
        sign = 1
        number = abs(number)



    whole, dec = str(number).split(".")
    # Convert both whole number and decimal
    # part from string type to integer type
    whole = int(whole)
    res = str(format(whole, f"0{places_int}b"))

    if (sign):
        res = two_complement(res)

    return res


def two_complement(res):
    '''
    :param res:  it is the binary representation of number
    :return: two complemnt of the number
    '''
    ones_complement = ""
    for i in range(len(res)):
        if res[i] == "0":
            ones_complement += "1"
        else:
            ones_complement += "0"

    two_complement = ""
    flag_flow = 1  # Initialize outside the loop
    for i in range(len(res) - 1, -1, -1):
        if flag_flow == 0:
            two_complement += ones_complement[i]
        elif ones_complement[i] == "1" and flag_flow:
            two_complement += "0"
            flag_flow = 1
        elif ones_complement[i] == "0" and flag_flow:
            two_complement += "1"
            flag_flow = 0

    return two_complement[::-1]  # Reverse the result to get the correct order


def convert_two_complement2decmail(bin_num, int_len=5):
    '''

    :param bin_num: the binary representation of the number     :param int_len:  of int bits
    :param float_len: number of fraction bits
    :return: the decimal value of the number
    '''
    bin_num_int = str(bin_num)
    dec_num = 0
    # convert binary intger to decmial
    for i in range(int_len):
        if i == 0:
            dec_num += int(bin_num_int[i]) * (-1) * 2 ** (int_len - 1 - i)
        else:
            dec_num += int(bin_num_int[i]) * (2) ** (int_len - 1 - i)


    return dec_num