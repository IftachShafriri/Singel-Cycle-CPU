`include "Include/Opcodes.v"

`ifndef register_data
`define register_data

`define Data_WIDTH 32
`define Number_of_Registers 64
`define PC_WIDTH 16
`define INSTRUCTION_WIDTH 32 // 5 for opcode 6 for register a,b,c 9 for const
`define REGISTER_ADDR_WIDTH ($clog2(`Number_of_Registers))
`define CONSTANT_WIDTH (`INSTRUCTION_WIDTH - `OPCODE_WIDTH - 3 * `REGISTER_ADDR_WIDTH)
`define BRANCH_OFFSET_WIDTH (`CONSTANT_WIDTH + `REGISTER_ADDR_WIDTH - 3)
`define COND_WIDTH 3
`define MEMORY_INSTRACTION_SIZE (1<<14) // 2^14
`define MEMORY_DATA_SIZE (1<<15) // 2^15
`define MEMORY_SIZE (`MEMORY_INSTRACTION_SIZE + `MEMORY_DATA_SIZE)
`define PROGRAM_FILE "program_file.hex"
`define DATA_FILE "data_file.hex"

`endif 
