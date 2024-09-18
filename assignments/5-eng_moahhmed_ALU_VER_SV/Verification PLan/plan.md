# Verification Plan

## Introduction
This document outlines the process for verifying the Arithmetic Logic Unit (ALU).

### Signal Description

#### Inputs
- **clk**: Active edge clock
- **reset_n**: Active low reset
- **op_code**: 2-bit opcode:
  - `2'b00`: `a | b` (bitwise OR)
  - `2'b01`: `a & b` (bitwise AND)
  - `2'b10`: `a + b` (addition)
  - `2'b11`: `a - b` (subtraction)
- **A**: 4-bit signed first variable input
- **B**: 4-bit signed second variable input

#### Outputs
- **C**: 4-bit output of the ALU operation
- **overflow**: A signal that goes high when overflow occurs during addition or subtraction.

### Test Cases
1. **Addition Test**: 
   - Overflow = 1 if `a(+) + b(+) = c(-)`
2. **Subtraction Test**: 
   - Overflow = 1 if `a(-) - b(+) = c(+)`
3. **OR Test**: 
   - Overflow must be 0
4. **AND Test**: 
   - Overflow must be 0
