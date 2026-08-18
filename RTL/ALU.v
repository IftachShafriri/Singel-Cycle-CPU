`include "Include/Opcodes.v"
`include "Include/DATA.v"

module ALU #(parameter WIDTH = `Data_WIDTH) (a, b, y, carry, op, overflow, zero, shift_amount);

input [WIDTH - 1 : 0] a, b ;
input [4 : 0] op ;
input [$clog2(WIDTH) : 0] shift_amount ;
output reg [WIDTH - 1 : 0] y ;
output reg carry, overflow ;
output zero ;


always @* begin
    carry = 1'b0;
    case(op)
    `OP_ADD: {carry, y} = a + b ; // ADD, ADDI
    `OP_SUB: y = a - b ; // SUB, SUBI
    `OP_AND: y = a & b ; // AND
    `OP_OR: y = a | b ; // OR
    `OP_XOR: y = a ^ b ; // XOR
    `OP_NOT: y = ~a ; // NOT
    `OP_EQ: y = ($signed(a) == $signed(b)) ; // Equal
    `OP_LT: y = ($signed(a) < $signed(b)) ; // Less then
    `OP_Shift_left: y = a << shift_amount ; // SHL
    `OP_Shift_rigth: y = a >> shift_amount ; // SHR
    `OP_Shift_rigth_sign: y = $signed(a) >>> shift_amount ; // SHR Sign Keeping
    `OP_Shift_Cycle: // SHL Cycle
        if (shift_amount == 0 )
            y = a;
        else 
            y = (a << shift_amount) | (a >> (WIDTH - shift_amount));
            
    default: y = {WIDTH{1'b0}} ;
    endcase
end

always @* begin
    case (op)
    `OP_ADD: overflow = (a[WIDTH-1] == b[WIDTH-1]) && (a[WIDTH-1] != y[WIDTH-1]) ;
    `OP_SUB: overflow = (a[WIDTH-1] != b[WIDTH-1]) && (a[WIDTH-1] != y[WIDTH-1]) ;
        default: overflow = 1'b0 ; 
    endcase
    
end
assign zero = (y == {WIDTH{1'b0}}) ;
endmodule