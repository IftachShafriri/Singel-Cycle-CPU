`ifndef OP_CODES
`define OP_CODES


`define OPCODE_WIDTH 5
`define OP_LD 5'b00000
`define OP_LDR 5'b00001
`define OP_ST 5'b00010 
`define OP_STR 5'b00011 
`define OP_LA 5'b00100
`define OP_LAR 5'b00101
`define OP_ADD 5'b00110 
`define OP_ADDI 5'b00111
`define OP_SUB 5'b01000 
`define OP_NEG 5'b01001 
`define OP_NOT 5'b01010 
`define OP_AND 5'b01011 
`define OP_ANDI 5'b01100 
`define OP_OR 5'b01101 
`define OP_ORI 5'b01110  
`define OP_XOR 5'b01111
`define OP_Shift_left 5'b10000
`define OP_Shift_rigth 5'b10001
`define OP_Shift_rigth_sign 5'b10010
`define OP_Shift_Cycle 5'b10011
`define OP_LT 5'b10100
`define OP_EQ 5'b10101



`endif 