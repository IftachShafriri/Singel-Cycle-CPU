`include "Include/Opcodes.v"
`include "Include/DATA.v"

module ALU #(parameter WIDTH = `Data_WIDTH) (a, b, y, carry, op, overflow, zero);

input [WIDTH - 1 : 0] a, b ;
input [`OPCODE_WIDTH -1 : 0] op ;
output reg [WIDTH - 1 : 0] y ;
output reg carry, overflow ;
output zero ;


always @* begin
    carry = 1'b0;
    case(op)
    `OP_ADD: {carry, y} = a + b ; // ADD, ADDI
    `OP_SUB: y = a - b ; // SUB
    `OP_AND: y = a & b ; // AND, ANDI
    `OP_OR: y = a | b ; // OR, ORI
    `OP_XOR: y = a ^ b ; // XOR
    `OP_NOT: y = ~a ; // NOT
    `OP_NEG: y = 0 
    `OP_EQ: y = ($signed(a) == $signed(b)) ; // Equal
    `OP_LT: y = ($signed(a) < $signed(b)) ; // Less then
    `OP_Shift_left: y = a << b ; // SHL
    `OP_Shift_rigth: y = a >> b ; // SHR
    `OP_Shift_rigth_sign: y = $signed(a) >>> b ; // SHR Sign Keeping
    `OP_Shift_Cycle: // SHL Cycle
        if (b == 0 )
            y = a;
        else 
            y = (a << b) | (a >> (WIDTH - b));
    
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