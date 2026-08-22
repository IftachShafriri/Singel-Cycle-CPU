`include "Opcodes.v"

`ifndef register_data
`define register_data

`define Data_WIDTH 32
`define Number_of_Registers 64
`define PC_WIDTH 16
`define INSTRUCTION_WIDTH 32 // 5 for opcode 6 for register a,b,c 9 for const
`define REGISTER_ADDR_WIDTH ($clog2(`Number_of_Registers))
`define CONSTANT_WIDTH (`INSTRUCTION_WIDTH - `OPCODE_WIDTH - 3 * `REGISTER_ADDR_WIDTH)

`endif 