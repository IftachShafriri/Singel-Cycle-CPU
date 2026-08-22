`include "Include/DATA.v"
`include "Include/Opcodes.v"

module PC(constant, select, clock, reset, stay, PC_out);
input clock, reset, stay;
input [1:0] select;
input [`CONSTANT_WIDTH - 1 : 0] constant;
output [`PC_WIDTH - 1 : 0] PC_out;

//wires
wire [`PC_WIDTH - 1 : 0] INC4_split, branch_wire, const_split, MUX_wire_connect, register_wire_connect ;
wire neg_wire_select

//ports
INC4 inc4_connect(
    .INC4_in(PC_out),
    .INC4_out(INC4_split));

BRANCH branch_connect(
    .Branch_in(PC_out),
    .constant_in(const_split),
    .Branch_out(branch_wire),
    .Neg_check_select(neg_wire_select));

Sign_Extension_Const Sign_Extension_connect(
    .constant_out(const_split),
    .constant_in(constant));

NEG_MUX_2_1 NEG_MUX_connect(
    .NEG_MUX_in_0(branch_wire),
    .NEG_MUX_in_1(INC4_split),
    .NEG_MUX_select(neg_wire_select),
    .NEG_MUX_out(MUX_wire_connect));
    
PC_MUX PC_MUX_connect(
    .MUX_in_00(INC4_split),
    .MUX_in_01(MUX_wire_connect),
    .MUX_in_10(const_split),
    .select(select),
    .PC_MUX_out(register_wire_connect));
    
PC_REGISTER PC_register_connect(
    .next_PC(register_wire_connect),
    .clk(clock),
    .reset(reset),
    .stay(stay),
    .PC_Register_out(PC_out));
endmodule



module PC_REGISTER(next_PC, clk, reset, stay, PC_Register_out);
input [`PC_WIDTH - 1 : 0] next_PC;
input clk, reset, stay;
output reg [`PC_WIDTH - 1 : 0] PC_Register_out;
always @(posedge clk) begin
    if (reset) 
        PC_Register_out <= 4'h0000;
    else if (stay)
        PC_Register_out <= PC_Register_out;
    else
        PC_Register_out <= next_PC;
end
endmodule



module PC_MUX(MUX_in_00, MUX_in_01, MUX_in_10, select, PC_MUX_out);
input [`PC_WIDTH - 1 : 0] MUX_in_00, MUX_in_01, MUX_in_10;
input [1:0] select;
reg [`PC_WIDTH - 1 : 0] MUX_out;
output [`PC_WIDTH - 1 : 0] PC_MUX_out;
always @* begin
    case(select) 
    2'b00 : MUX_out = MUX_in_00;
    2'b01 : MUX_out = MUX_in_01;
    2'b10 : MUX_out = MUX_in_10;
    default : MUX_out = MUX_in_00;
    endcase
end
assign PC_MUX_out = {MUX_out[`PC_WIDTH - 1 : 2], 2'b00};
endmodule


module NEG_MUX_2_1(NEG_MUX_in_0, NEG_MUX_in_1, NEG_MUX_select, NEG_MUX_out);
input [`PC_WIDTH - 1 : 0] NEG_MUX_in_0, NEG_MUX_in_1;
input NEG_MUX_select;
output reg [`PC_WIDTH - 1 : 0] NEG_MUX_out;
always @* begin
    case(NEG_MUX_select)
    1'b0 : NEG_MUX_out =  NEG_MUX_in_0; // BRANCH
    1'b1 : NEG_MUX_out =  NEG_MUX_in_1; // INC4
    endcase
end
endmodule


module INC4(INC4_in, INC4_out);
input [`PC_WIDTH - 1 : 0] INC4_in;
output [`PC_WIDTH - 1 : 0] INC4_out;
assign INC4_out = INC4_in + 4'h0004;
endmodule


module Sign_Extension_Const(constant_in, constant_out);
input [`CONSTANT_WIDTH - 1 : 0] constant_in;
output [`PC_WIDTH - 1 : 0] constant_out;
assign constant_out = {{(`PC_WIDTH - `CONSTANT_WIDTH){constant_in[`CONSTANT_WIDTH - 1]}}, constant_in};
endmodule


module BRANCH(Branch_in, constant_in, Branch_out,Neg_check_select);
input [`PC_WIDTH - 1 : 0] Branch_in ,constant_in;
output [`PC_WIDTH - 1 : 0] Branch_out;
wire [`PC_WIDTH  : 0] wire_check;
output Neg_check_select;
assign wire_check = {1'b0, Branch_in} + {constant_in[`PC_WIDTH - 1], constant_in};
assign Neg_check_select = wire_check[`PC_WIDTH]; // if == 1 num < 0 else == 0 num >0
assign Branch_out = wire_check[`PC_WIDTH - 1 : 0];
endmodule


