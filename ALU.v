module ALU #(parameter WIDTH = 4) (a, b, y, carry, op, overflow, zero, shift_amount);

input [WIDTH - 1 : 0] a, b ;
input [4 : 0] op ;
input [ceil(log2(WIDTH)) : 0] shift_amount ;
output reg [WIDTH - 1 : 0] y ;
output reg carry, overflow ;
output zero ;

// Setting Parameter OPCODE
parameter OP_ADD = 5'b00000 ;
parameter OP_SUB = 5'b00001 ;
parameter OP_AND = 5'b00010 ;
parameter OP_OR = 5'b00011 ;
parameter OP_XOR = 5'b0100 ;
parameter OP_NOT = 5'b00101 ;
parameter  OP_Shift_left = 5'b00110 ;
parameter  OP_Shift_rigth = 5'b00111 ;
parameter  OP_Shift_rigth_sign = 5'b01000 ;
parameter  OP_Shift_Cycle= 5'b01001 ;
parameter OP_LT = 5'b01010 ;
parameter OP_EQ = 5'b01011 ;
//parameter  = 5'b01100 ;
//parameter  = 5'b01101 ;
//parameter  = 5'b01111;

always @* begin
    carry = 1'b0;
    case(op)
    OP_ADD: {carry, y} = a + b ; // ADD, ADDI
    OP_SUB: y = a - b ; // SUB, SUBI
    OP_AND: y = a & b ; // AND
    OP_OR: y = a | b ; // OR
    OP_XOR: y = a ^ b ; // XOR
    OP_NOT: y = ~a ; // NOT
    OP_EQ: y = ($signed(a) == $signed(b)) ; // Equal
    OP_LT: y = ($signed(a) < $signed(b)) ; // Less then
    OP_Shift_left: y = a << shift_amount ; // SHL
    OP_Shift_rigth: y = a >> shift_amount ; // SHR
    OP_Shift_rigth_sign: y = $signed(a) >>> shift_amount ; // SHR Sign Keeping
    OP_Shift_Cycle: // SHL Cycle
        if (shift_amount == 0 )
            y = a;
        else 
            y = (a << shift_amount) | (a >> (WIDTH - shift_amount));

    end
    default: y = {WIDTH{1'b0}} ;
    endcase
end

always @* begin
    case (op)
    OP_ADD: overflow = (a[WIDTH-1] == b[WIDTH-1]) && (a[WIDTH-1] != y[WIDTH-1]) ;
    OP_SUB: overflow = (a[WIDTH-1] != b[WIDTH-1]) && (a[WIDTH-1] != y[WIDTH-1]) ;
        default: overflow = 1'b0 ; 
    endcase
    
end
assign zero = (y == {WIDTH{1'b0}}) ;
endmodule