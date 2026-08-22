`include "Include/Opcodes.v"
`include "Include/DATA.v"

module CONTROL_BLOCK(
    INSTRUCTION,
    Ra, Rb, Rc,
    Rrb_out, Rrc_out,
    PC_select_out
    );
endmodule

//BLOCK A 

module BLOCK_A(op, rb, PC_in, Rrb_in, A_BLOCK_out);
input [`OPCODE_WIDTH - 1 : 0] op;
input [`REGISTER_ADDR_WIDTH - 1: 0] rb;
input [`Data_WIDTH - 1 : 0] Rrb_in;
input [`Data_WIDTH - 1 : 0] PC_in;
output [`Data_WIDTH - 1 : 0] A_BLOCK_out;
wire [1:0] A_select;

logic_MUX_A logic_MUX_BLOCK_A_connect(.rb(rb), .op(op), .logic_MUX_A_out(A_select));
MUX_A MUX_BLOCK_A_connect(.Rrb_MUX_A_in(Rrb_in) , .PC_MUX_A_in(PC_in), .MUX_A_sel(A_select) , .MUX_A_out(A_BLOCK_out));
endmodule

module logic_MUX_A(rb,op,logic_MUX_A_out);
input [`OPCODE_WIDTH - 1 : 0] op;
input [`REGISTER_ADDR_WIDTH - 1: 0] rb;
output reg [1:0] logic_MUX_A_out;
always @* begin
if (op == 5'b01001) // NEG
    logic_MUX_A_out = 2'b10;
else if ((op == 5'b00000) || (op == 5'b00010) || (op == 5'b00100))
    if (rb == {`REGISTER_ADDR_WIDTH{1'b0}})
        logic_MUX_A_out = 2'b10;
    else
        logic_MUX_A_out = 2'b00;
else if ((op == 5'b00001) || (op == 5'b00011) || (op == 5'b00101))
        logic_MUX_A_out = 2'b01;
else
        logic_MUX_A_out = 2'b00;
end
endmodule

module MUX_A(Rrb_MUX_A_in, PC_MUX_A_in, MUX_A_select, MUX_A_out);
input [`Data_WIDTH - 1 : 0] Rrb_MUX_A_in;
input [`Data_WIDTH - 1 : 0] PC_MUX_A_in;
input [1 : 0] MUX_A_select;
output reg [`Data_WIDTH - 1 : 0] MUX_A_out;
always @* begin
    case(MUX_A_select)
        2'b00: MUX_A_out = Rrb_MUX_A_in;
        2'b01: MUX_A_out = PC_MUX_A_in;
        2'b10: MUX_A_out = 0;
        default: MUX_A_out = Rrb_MUX_A_in;
    endcase
end
endmodule

//BLOCK B
module BLOCK_A(C1, C2, Rrc_in, )
endmodule

module shift_MUX_extended(Rrc_in, C3, shift_select, shift_amount);
input [$clog2(`Data_WIDTH) - 1 : 0] Rrc_in;
input [$clog2(`Data_WIDTH) - 1 : 0] C3;
reg [$clog2(`Data_WIDTH) - 1 : 0] shift_MUX_out;
always @* begin
    case(C3 == 0)
    1'b0: shift_MUX_out = C3;
    1'b1: shift_MUX_out = Rrc_in;
    default: shift_MUX_out = C3;
    endcase
end
assign shift_amount = {{{`Data_WIDTH - $clog2(`Data_WIDTH)}1'b0},shift_MUX_out};
endmodule

module MUX_B(shift_amount, Rrc_MUX_B_in, C1_in, C2_in, MUX_B_select, MUX_B_out);
input [`Data_WIDTH - 1 : 0] Rrc_MUX_B_in;
input [`Data_WIDTH - 1 : 0] C1_in;
input [`Data_WIDTH - 1 : 0] C2_in;
input [`Data_WIDTH - 1 : 0] shift_amount;
input [1 : 0] MUX_B_select;
output reg [`Data_WIDTH - 1 : 0] MUX_B_out;
always @* begin
    case(MUX_B_select)
        2'b00: MUX_B_out = Rrc_MUX_B_in;
        2'b01: MUX_B_out = C1_in;
        2'b10: MUX_B_out = C2_in;
        2'b11: MUX_B_out = shift_amount;
        default: MUX_B_out = Rrc_MUX_B_in;
    endcase
end
endmodule


module logic_MUX_B();
endmodule
