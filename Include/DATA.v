`ifndef register_data
`define register_data

`define Data_WIDTH 4
`define Number_of_Registers 64
`define PC_WIDTH 16
`define INSTRUCTION_WIDTH 32 // 5 for opcode 6 for register a,b,c 9 for const
`define Register_bit_number ($clog2(64))
`endif 