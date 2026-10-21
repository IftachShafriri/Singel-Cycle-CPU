`include "Include/Opcodes.v"
`include "Include/DATA.v"

module ALU_tb;
localparam WIDTH = `Data_WIDTH; 
reg [WIDTH - 1 : 0] a ,b ;
reg [4 : 0] op;
reg [$clog2(WIDTH) : 0] shift_amount;
reg [WIDTH-1:0] expected;
wire [WIDTH - 1 : 0] y;
wire overflow, carry, zero;

ALU dut(.a(a),
        .b(b),
        .op(op),
        .shift_amount(shift_amount),
        .y(y),
        .overflow(overflow),
        .carry(carry),
        .zero(zero));

integer j;

initial 
begin
    
for (j = 0; j < 10; j = j + 1) begin
    a = $random;
    b= $random;
    op = $random;
    shift_amount = $random;

    while (op > 5'b01011) begin
        op = $random;
    end
    case(op)
    `OP_ADD: expected = a + b;
    `OP_SUB: expected = a - b ; // SUB, SUBI
    `OP_AND: expected = a & b ; // AND
    `OP_OR: expected = a | b ; // OR
    `OP_XOR: expected = a ^ b ; // XOR
    `OP_NOT: expected = ~a ; // NOT
    `OP_EQ: expected = ($signed(a) == $signed(b)) ; // Equal
    `OP_LT: expected = ($signed(a) < $signed(b)) ; // Less then
    `OP_Shift_left: expected = a << shift_amount ; // SHL
    `OP_Shift_rigth: expected = a >> shift_amount ; // SHR
    `OP_Shift_rigth_sign: expected = $signed(a) >>> shift_amount ; // SHR Sign Keeping
    `OP_Shift_Cycle: // SHL Cycle
        if (shift_amount == 0 )
            expected = a;
        else 
            expected = (a << shift_amount) | (a >> (WIDTH - shift_amount));
            
    default: expected = {WIDTH{1'b0}} ;
    endcase
    #1
    if (y == expected)
        $display("PASS");
    else
        $display("FAIL");
    #1
    $display("a = %b, b = %b, y = %b, expected = %b, overflow = %b, carry = %b, zero = %b" ,a, b, y, expected, overflow, carry, zero);
    end


    #1
    $display("a = %b, b = %b, y = %b, expected = %b, overflow = %b, carry = %b, zero = %b" ,a, b, y, expected, overflow, carry, zero);
    


a = 4'b1111;
b = 4'b0001;
op = 5'b00000;
#1;
$display("a = %b, b = %b, op = %b, y = %b, overflow = %b, carry = %b, zero = %b" ,a, b, op, y, overflow, carry, zero);

a = 4'b0111;
b = 4'b0001;
op = 5'b00000;
#1;
$display("a = %b, b = %b, op = %b, y = %b, overflow = %b, carry = %b, zero = %b" ,a, b, op, y, overflow, carry, zero);

a = 4'b0110;
op = 5'b01001;
shift_amount = 3'b100;
#1;
$display("a = %b, op = %b, shift_amount = %b, y = %b" ,a, op, shift_amount, y);

a = 4'b0110;
op = 5'b00110;
shift_amount = 3'b100;
#1;
$display("a = %b, op = %b, shift_amount = %b, y = %b" ,a, op, shift_amount, y);

a = 4'b0110;
op = 5'b00111;
shift_amount = 3'b000;
#1;
$display("a = %b, op = %b, shift_amount = %b, y = %b" ,a, op, shift_amount, y);

a = 4'b0110;
op = 5'b01000;
shift_amount = 3'b000;
#1;
$display("a = %b, op = %b, shift_amount = %b, y = %b" ,a, op, shift_amount, y);

a = 4'b0000;
op = 5'b00101;
#1;
$display("a = %b, op = %b, y = %b" ,a, op, y);

a = 4'b1000;
b = 4'b0001;
op = 5'b00001;
#1;
$display("a = %b, b = %b, op = %b, y = %b, overflow = %b, carry = %b, zero = %b" ,a, b, op, y, overflow, carry, zero);

a = 4'b1111;
b = 4'b0001;
op = 5'b01010;
#1;
$display("a = %b, b = %b, op = %b, y = %b" ,a, b, op, y);

a = 4'b1111;
b = 4'b0001;
op = 5'b01011;
#1;
$display("a = %b, b = %b, op = %b, y = %b" ,a, b, op, y);

$finish;
end
endmodule