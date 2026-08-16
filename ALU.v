module ALU #(parameter WIDTH = 4) (a, b, y, carry, op, overflow, zero, shift_amount);

input [WIDTH - 1 : 0] a, b ;
input [3 : 0] op ;
input [1 : 0] shift_amount ;
output reg [WIDTH - 1 : 0] y ;
output reg carry, overflow ;
output reg zero ;
// Setting Parameter OPCODE
parameter OP_ADD = 4'b0000 ;
parameter OP_SUB = 4'b0001 ;
parameter OP_AND = 4'b0010 ;
parameter OP_OR = 4'b0011 ;
parameter OP_XOR = 4'b0100 ;
parameter OP_NOT = 4'b0101 ;
parameter OP_MUL = 4'b0110 ;
parameter OP_DIV = 4'b0111 ;
parameter OP_MOD = 4'b1000 ;
parameter OP_EQ = 4'b1001 ;
parameter OP_LT = 4'b1010 ;
parameter OP_Shift_left = 4'b1011 ;
parameter OP_Shift_rigth = 4'b1100 ;
parameter OP_Shift_left_sign = 4'b1101 ;
parameter OP_Shift_rigth_sign = 4'b1111;


always @* begin
    carry = 1'b0;
    case(op)
    3
