# Function returns octal representation
import numpy as np
from binary_fractions import Binary


def float_bin(number, places_int, places_float):
    '''
    Converts a floating-point number to its binary representation.

    :param number: The float number to convert to binary.
    :param places_int: Number of integer bits to represent the integer part of the number.
    :param places_float: Number of bits to represent the fractional part of the number.
    :return: Binary representation of the number with a total of (places_int + places_float) bits.
    '''

    # Initialize the sign bit (0 for positive, 1 for negative)
    sign = 0
    number = float(number)

    # If the number is negative, set the sign bit and take the absolute value
    if number < 0:
        sign = 1
        number = abs(number)

    # Split the number into the integer (whole) and decimal (fractional) parts
    if number < 1:
        whole, dec = 0, float(number)
    else:
        whole, dec = str(number).split(".")
        dec = float("." + dec)

    # Convert the integer part to binary, ensuring it has the correct number of bits
    whole = int(whole)
    res = str(format(whole, f"0{places_int}b"))

    # Convert the decimal part to binary if it exists
    if dec > 0:
        fraction_in_bin = str(Binary(dec))  # Convert decimal to binary
        _, fraction_in_bin_2 = fraction_in_bin.split(".")
        fraction_rep = fraction_in_bin_2[0:places_float]

        # Ensure that the fraction representation has the correct number of bits
        if len(fraction_rep) != places_float:
            fraction_rep += "0" * (places_float - len(fraction_rep))

        # Append the fractional part to the result
        res += fraction_rep
    else:
        # If no decimal part, append '0' bits for the fractional part
        res += str(format(0, f"0{places_float}b"))

    # If the number was negative, convert the result to two's complement
    if sign:
        res = two_complement(res)

    return res


def two_complement(res):
    '''
    Converts a binary string into its two's complement representation.

    :param res: The binary representation of the number.
    :return: Two's complement of the binary number.
    '''

    # Compute one's complement by flipping the bits
    ones_complement = ""
    for i in range(len(res)):
        if res[i] == "0":
            ones_complement += "1"
        else:
            ones_complement += "0"

    # Compute two's complement by adding 1 to the one's complement
    two_complement = ""
    flag_flow = 1  # Carry-in for adding 1 (initialized to 1)

    # Perform the addition from the least significant bit to the most significant bit
    for i in range(len(res) - 1, -1, -1):
        if flag_flow == 0:
            two_complement += ones_complement[i]
        elif ones_complement[i] == "1" and flag_flow:
            two_complement += "0"
            flag_flow = 1
        elif ones_complement[i] == "0" and flag_flow:
            two_complement += "1"
            flag_flow = 0

    # Return the reversed result as we computed it from least to most significant bit
    return two_complement[::-1]


def convert_two_complement2decimal(bin_num, int_len, float_len):
    '''
    Converts a two's complement binary string to its decimal representation.

    :param bin_num: The binary representation of the number.
    :param int_len: Number of bits in the integer part.
    :param float_len: Number of bits in the fractional part.
    :return: Decimal value of the two's complement binary number.
    '''

    # Split the binary number into integer and fractional parts
    bin_num_int = bin_num[0:int_len]
    bin_num_float = bin_num[int_len:]

    dec_num = 0
    # Convert the integer part from binary to decimal
    for i in range(int_len):
        if i == 0:
            # Handle the sign bit (MSB), which represents negative if it's 1
            dec_num += int(bin_num_int[i]) * (-1) * 2 ** (int_len - 1 - i)
        else:
            # Convert the remaining integer bits normally
            dec_num += int(bin_num_int[i]) * (2) ** (int_len - 1 - i)

    # Convert the fractional part from binary to decimal
    for i in range(1, float_len + 1):
        dec_num += int(bin_num_float[i - 1]) * (2 ** (-i))

    return dec_num


def calculate_error(estimated, actual):
    """
    Calculates the relative error between estimated and actual values, expressed as a percentage.

    Parameters:
    estimated (float): The estimated value.
    actual (float): The actual value.

    Returns:
    str: The relative error as a percentage in string format.
    """
    return (estimated - actual) / (actual+.0000000000000000000000000000000000000001) * 100  # Format as percentage with 2 decimal places


def write_to_file(file_name, xn, xn_filtered,xn_filtered_1, places_int, places_float, mode="w"):
    """
    Converts input and output signals to floating-point binary format, calculates the errors, and writes the results to a file.

    Parameters:
    file_name (str): The path of the file to write the results.
    xn (list): List of input signal values.
    xn_filtered (list): List of filtered output signal values.
    places_int (int): Number of bits for the integer part in the binary conversion.
    places_float (int): Number of bits for the fractional part in the binary conversion.
    mode (str, optional): The file writing mode. Defaults to 'w' (write mode).

    Returns:
    None: Writes lines to the file.
    """

    arr = []  # Initialize an empty list to store lines for the file
    in_error=[]
    op1_error=[]
    op2_error=[]

    count=0
    for input, output1,output2 in zip(xn, xn_filtered,xn_filtered_1):
        # Convert input and output values to floating-point binary format
        in_ = float_bin(input, places_int, places_float)
        op_1 = float_bin(output1, places_int, places_float)
        op_2 = float_bin(output2, places_int, places_float)

        # Convert two's complement binary format to decimal for comparison
        in_dec = convert_two_complement2decimal(in_, places_int, places_float)
        op1_dec = convert_two_complement2decimal(op_1, places_int, places_float)
        op2_dec = convert_two_complement2decimal(op_2, places_int, places_float)

        # Calculate and print the error between the original and the converted decimal values
        in_error.append(calculate_error(in_dec, input))
        op1_error.append(calculate_error(op1_dec, output1))
        op2_error.append(calculate_error(op2_dec, output2))
        count+=1
        # Append the binary strings (input and output) to the array for writing to file  and prevert to add new line to last line
        if(count!=len(xn)):
           arr.append(f"{in_} {op_1} {op_2}\n")
        else:
            arr.append(f"{in_} {op_1} {op_2}\n")

    # Write the lines to the file in the specified mode (write or append)
    with open(file_name, mode) as file:
        file.writelines(arr)


    return np.average(in_error),np.average(op1_error),np.average(op2_error)




