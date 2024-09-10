# AHB-Lite System Components

- **Master**: Initiates transfers on the bus.
- **Slave**: Responds to requests from the master. Both high and low bandwidth peripherals can act as slaves.
- **Decoder**: Determines which slave is selected for a transfer.
- **MUX**: Multiplexes the data and control signals between master and slave.


## Global Signals

| Name    | Source          | Description                                   |
|---------|-----------------|-----------------------------------------------|
| HCLK    | PLL              | AMBA clock, all blocks work on posedge        |
| HRESETn | Reset Controller | Active low reset                              |

## Master Signals

| Name       | Destination                  | Description                                                                 |
|------------|------------------------------|-----------------------------------------------------------------------------|
| HADDR      | Slave & Decoder              | 32-bit address bus                                                          |
| HBURST     | Slave                        | 3-bit signal, increment either fixed (4,8,16) or undefined, wrapping        |
| HMASTLOCK  | Slave                        | If high, slave is in a locked sequence                                      |
| HPORT      | Slave                        | 4-bit, indicates opcode fetch or data access, privileged/user mode access   |
| HSIZE      | Slave                        | 3-bit, maps to transfer size (byte, half-word, word, up to 1024b)           |
| HTRANS     | Slave                        | Transfer type [IDLE, BUSY, NONSEQUENTIAL, SEQUENTIAL]                       |
| HWDATA     | Slave                        | 32-bit write data (recommended)                                             |
| HWRITE     | Slave                        | High: Write, Low: Read                                                      |

## Slave Signals

| Name       | Destination | Description                                                 |
|------------|-------------|-------------------------------------------------------------|
| HRDATA     | MUX         | 32-bit data from slave to MUX to master                     |
| HREADYOUT  | MUX         | High if transfer is finished, low if more time is needed    |
| HRESP      | MUX         | Low: No error, High: Transfer error                         |

## Decoder Signals

| Name   | Destination | Description                                                                 |
|--------|-------------|-----------------------------------------------------------------------------|
| HSELxa | MUX         | Signal to select slave; ensures previous transfer is done before next one   |

## MUX Signals

| Name     | Destination          | Description                               |
|----------|----------------------|-------------------------------------------|
| HRDATA   | Master               | Read data bus, selected by the decoder    |
| HREADY   | Master & All Slaves  | High if transfer is finished              |
| HRESP    | Master               | Transfer response, selected by the decoder |


## transfer Cycle :
 1. **Address phase:** one address and control cycle.
 2. **data phase:**one or more cycles for the data.



## simple transfer with no wait states:
 1. The master drives the address and control signals onto the bus after the rising edge of HCLK.
 2. The slave then samples the address and control information on the next rising edge of HCLK.
 3. After the slave has sampled the address and control it can start to drive the 
    appropriate HREADY response.
    This response is sampled by the master on the third rising edge of HCLK.
 
## Transfer Types

| HTRANS[1:0] | Type     | Description                                                                                                                                                                                                 |
|-------------|----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 2'b00       | IDLE     | Slaves must always provide a zero wait state OKAY response to IDLE transfers and the transfer must be ignored by the slave.                                                                                  |
| 2'b01       | BUSY     | The BUSY transfer type allows masters to insert idle cycles within a burst, indicating a delay in the next transfer. The address and control signals must reflect the next transfer. Only undefined length bursts can end with a BUSY transfer. Slaves must respond with a zero wait state OKAY and ignore the transfer. |
| 2'b10       | NONSEQ   | A NONSEQUENTIAL transfer indicates a single transfer or the first transfer of a burst. The address and control signals are unrelated to the previous transfer. Single transfers on the bus are treated as bursts of length one and are therefore classified as NONSEQUENTIAL. |
| 2'b11       | SEQ      | SEQUENTIAL transfers are the remaining transfers in a burst where the address is related to the previous transfer. The control information remains the same as the previous transfer. The address is calculated as the previous address plus the transfer size (signaled by the HSIZE[2:0] signals). For wrapping bursts, the address wraps at the address boundary. |








**Burst Transfers**: These consist of multiple data transfers (or beats) that are grouped together. This allows for more efficient data    
                     transfer compared to single transfers, as the address and control information is sent only once at the beginning of the burst.


**Types of Bursts**:

**Single**: A single data transfer.
**Incrementing Bursts**: The address increments after each transfer, but does not wrap at address boundaries.
**Wrapping Bursts**: The address wraps around at particular address boundaries, useful for circular buffers.
**BUSY Transfer**: Allows masters to insert idle cycles within a burst, indicating that the next transfer cannot take place immediately