`include "Include/Opcodes.v"
`include "Include/DATA.v"

module ALU #(parameter WIDTH = `Data_WIDTH) (a, b, y, ALU_OP, overflow, zero);

input signed [WIDTH - 1 : 0] a, b ;
input [`ALU_OPCODE_WIDTH -1 : 0] ALU_OP ;
output reg signed [WIDTH - 1 : 0] y ;
output reg overflow ;
output zero ;


always @* begin
    carry = 1'b0;
    case(ALU_OP)
    `ALU_ADD: {carry, y} = a + b ; // ADD, ADDI
    `ALU_SUB: y = a - b ; // SUB
    `ALU_AND: y = a & b ; // AND, ANDI
    `ALU_OR: y = a | b ; // OR, ORI
    `ALU_XOR: y = a ^ b ; // XOR
    `ALU_NOT: y = ~b ; // NOT 
    `ALU_EQ: y = (a == b) ; // Equal
    `ALU_LT: y = (a < b) ; // Less then
    `ALU_SHIFT_LEFT: y = a << b ; // SHL
    `ALU_SHIFT_RIGHT: y = a >> b ; // SHR
    `ALU_SHIFT_RIGHT_SIGN: y = a >>> b ; // SHR Sign Keeping
    `ALU_SHIFT_CYCLE: // SHL Cycle
        if (b == 0 )
            y = a;
        else 
            y = (a << b) | (a >> (WIDTH - b));
    
    default: y = {WIDTH{1'b0}} ;
    endcase
end

always @* begin
    case (ALU_OP)
    `ALU_ADD: overflow = (a[WIDTH-1] == b[WIDTH-1]) && (a[WIDTH-1] != y[WIDTH-1]) ;
    `ALU_SUB: overflow = (a[WIDTH-1] != b[WIDTH-1]) && (a[WIDTH-1] != y[WIDTH-1]) ;
        default: overflow = 1'b0 ; 
    endcase
    
end
assign zero = (y == {WIDTH{1'b0}}) ;
endmodule