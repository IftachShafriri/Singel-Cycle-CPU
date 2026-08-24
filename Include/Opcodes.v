`ifndef OP_CODES
`define OP_CODES


`define OPCODE_WIDTH 5
`define OP_ADD 5'b00000 //ADD
`define OP_ADDI 5'b00001 //ADD
`define OP_SUB 5'b00010 //SUB
`define OP_NEG 5'b00011 //SUB
`define OP_NOT 5'b00100 //NOT
`define OP_AND 5'b00101 //AND
`define OP_ANDI 5'b00110 //AND
`define OP_OR 5'b00111 //OR
`define OP_ORI 5'b01000 //OR
`define OP_XOR 5'b01001 //XOR
`define OP_XORI 5'b01010 //XOR
`define OP_SHIFT_LEFT 5'b01011 // SHIFT
`define OP_SHIFT_RIGHT 5'b01100 // SHIFT
`define OP_SHIFT_RIGHT_SIGN 5'b01101 // SHIFT
`define OP_SHIFT_CYCLE 5'b01110 // SHIFT
`define OP_LT 5'b01111 //LT
`define OP_LTI 5'b10000 //LT
`define OP_EQ 5'b10001 // EQ
`define OP_EQI 5'b10010 //EQ
`define OP_LA 5'b10011 //LOAD
`define OP_LAR 5'b10100 //LOAD
`define OP_LD 5'b10101 //LOAD
`define OP_LDR 5'b10110 //LOAD
`define OP_ST 5'b10111 // STORE
`define OP_STR 5'b11000 // STORE
`define OP_BRANCH 5'b11001 // BRANCH
`define OP_JUMP 5'b11010 // JUMP


`define ALU_OPCODE_WIDTH 4
`define ALU_ADD 4'b0000
`define ALU_SUB 4'b0001
`define ALU_AND 4'b0010
`define ALU_OR 4'b0011
`define ALU_XOR 4'b0100
`define ALU_NOT 4'b0101
`define ALU_EQ 4'b0110
`define ALU_LT 4'b0111
`define ALU_SHIFT_LEFT 4'b1000
`define ALU_SHIFT_RIGHT 4'b1001
`define ALU_SHIFT_RIGHT_SIGN 4'b1010
`define ALU_SHIFT_CYCLE 4'b1011

`endif 

