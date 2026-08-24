`include "Include/Opcodes.v"
`include "Include/DATA.v"
//////////////////////////////////////
//MAIN CONTROL BLOCK
module CONTROL_BLOCK(INSTRUCTION, Rrb_in, Rrc_in,PC_select_out, ALU_OP, ALU_A_in, ALU_B_in ,MEM_enable_write, RF_enable_write, write_MUX_select,PC, Ra, Rb, Rc);
input [`INSTRUCTION_WIDTH - 1 : 0] INSTRUCTION;
input [`Data_WIDTH -1 : 0] Rrb_in, Rrc_in;
input [`PC_WIDTH -1 : 0] PC;
output reg MEM_enable_write, RF_enable_write, write_MUX_select;
output reg [`ALU_OPCODE_WIDTH -1 : 0] ALU_OP;
output [`Data_WIDTH -1 : 0] ALU_A_in, ALU_B_in;
output [`REGISTER_ADDR_WIDTH - 1 : 0] Ra, Rb, Rc;
output [1:0] PC_select_out;
wire [`OPCODE_WIDTH - 1 : 0] op;
wire [`CONSTANT_WIDTH - 1 : 0] C3; // 9
wire [`CONSTANT_WIDTH + `REGISTER_ADDR_WIDTH - 1 : 0] C2; // 15
wire [`CONSTANT_WIDTH + 2 * `REGISTER_ADDR_WIDTH - 1 : 0] C1; // 21
wire [`Data_WIDTH -1 : 0] PC_extended;
wire [`Data_WIDTH -1 : 0] C1_extended, C2_extended;
assign op = INSTRUCTION [`INSTRUCTION_WIDTH - 1 : `INSTRUCTION_WIDTH - `OPCODE_WIDTH];
assign Ra = INSTRUCTION [`INSTRUCTION_WIDTH - `OPCODE_WIDTH - 1 : `INSTRUCTION_WIDTH - `OPCODE_WIDTH - `REGISTER_ADDR_WIDTH];
assign Rb = INSTRUCTION [`INSTRUCTION_WIDTH - `OPCODE_WIDTH - `REGISTER_ADDR_WIDTH - 1 : `INSTRUCTION_WIDTH - `OPCODE_WIDTH - 2 * `REGISTER_ADDR_WIDTH];
assign Rc = INSTRUCTION [`INSTRUCTION_WIDTH - `OPCODE_WIDTH - 2 *  `REGISTER_ADDR_WIDTH - 1 : `CONSTANT_WIDTH];
assign C3 = INSTRUCTION [`CONSTANT_WIDTH - 1 : 0];
assign C2 = INSTRUCTION [`CONSTANT_WIDTH + `REGISTER_ADDR_WIDTH  - 1: 0];
assign C1 = INSTRUCTION [`CONSTANT_WIDTH + 2 * `REGISTER_ADDR_WIDTH - 1 : 0];
assign PC_extended = {{(`Data_WIDTH - `PC_WIDTH){1'b0}} ,PC};
assign C1_extended = {{(`Data_WIDTH - (`CONSTANT_WIDTH + 2 * `REGISTER_ADDR_WIDTH)){C1[`CONSTANT_WIDTH + 2 * `REGISTER_ADDR_WIDTH - 1]}},C1};
assign C2_extended = {{(`Data_WIDTH - (`CONSTANT_WIDTH + `REGISTER_ADDR_WIDTH )){C2[`CONSTANT_WIDTH + `REGISTER_ADDR_WIDTH - 1]}},C2};


BLOCK_A BLOCK_A_connect(.rb(Rb), .PC_in(PC_extended), .Rrb_in(Rrb_in), .op(op), .A_BLOCK_out(ALU_A_in));
BLOCK_B BLOCK_B_connect(.C1(C1_extended), .C2(C2_extended), .C3(C3[$clog2(`Data_WIDTH)-1:0]), .op(op), .Rrc_in(Rrc_in), .B_BLOCK_out(ALU_B_in));
COND_BLOCK COND_BLOCK_connect(.C3_cond_in(C3[`COND_WIDTH - 1 : 0]), .op(op), .Rrb_cond_in(Rrb_in), .PC_select(PC_select_out));

always @* begin
    MEM_enable_write = ((op == `OP_ST) || (op == `OP_STR));
    RF_enable_write = (op < `OP_ST);
end
always @* begin
    if ((op == `OP_LD) || (op == `OP_LDR))
        write_MUX_select = 1'b1;
    else
        write_MUX_select = 1'b0;

end
always @* begin
    case(op)
    `OP_ADD, `OP_ADDI, `OP_LA, `OP_LAR, `OP_LD, `OP_LDR, `OP_ST, `OP_STR: ALU_OP = `ALU_ADD;
    `OP_SUB, `OP_NEG: ALU_OP = `ALU_SUB;
    `OP_NOT: ALU_OP = `ALU_NOT;
    `OP_AND, `OP_ANDI: ALU_OP = `ALU_AND;
    `OP_OR, `OP_ORI: ALU_OP = `ALU_OR;
    `OP_XOR, `OP_XORI: ALU_OP = `ALU_XOR;
    `OP_SHIFT_LEFT: ALU_OP = `ALU_SHIFT_LEFT;
    `OP_SHIFT_RIGHT: ALU_OP = `ALU_SHIFT_RIGHT;
    `OP_SHIFT_RIGHT_SIGN: ALU_OP = `ALU_SHIFT_RIGHT_SIGN;
    `OP_SHIFT_CYCLE: ALU_OP = `ALU_SHIFT_CYCLE;
    `OP_LT, `OP_LTI: ALU_OP = `ALU_LT;
    `OP_EQ, `OP_EQI: ALU_OP = `ALU_EQ;
    default: ALU_OP = `ALU_ADD;
    endcase
end

endmodule

//////////////////////////////////////
//CONDITION BLOCK 
module COND_BLOCK(C3_cond_in, op, Rrb_cond_in, PC_select);
input [`OPCODE_WIDTH - 1 : 0] op;
input [`COND_WIDTH - 1:0] C3_cond_in;
input signed [`Data_WIDTH -1 : 0] Rrb_cond_in;
output reg [1:0] PC_select;
always @* begin
    PC_select = 2'b00;
    if (op == `OP_JUMP)
        PC_select =2'b10;
    else if (op == `OP_BRANCH) begin
        if (((C3_cond_in == 3'b000) && (Rrb_cond_in == 0)) ||
            ((C3_cond_in == 3'b001) && (Rrb_cond_in != 0)) ||
            ((C3_cond_in == 3'b010) && (Rrb_cond_in >= 0)) ||
            ((C3_cond_in == 3'b011) && (Rrb_cond_in < 0)))
            PC_select = 2'b01;
    end 
end
endmodule
//////////////////////////////////////
//BLOCK A 
module BLOCK_A(op, rb, PC_in, Rrb_in, A_BLOCK_out);
input [`OPCODE_WIDTH - 1 : 0] op;
input [`REGISTER_ADDR_WIDTH - 1: 0] rb;
input [`Data_WIDTH - 1 : 0] Rrb_in;
input [`Data_WIDTH - 1 : 0] PC_in;
output [`Data_WIDTH - 1 : 0] A_BLOCK_out;
wire [1:0] A_select;

logic_MUX_A logic_MUX_BLOCK_A_connect(.rb(rb), .op(op), .logic_MUX_A_out(A_select));
MUX_A MUX_BLOCK_A_connect(.Rrb_MUX_A_in(Rrb_in), .PC_MUX_A_in(PC_in), .MUX_A_select(A_select) , .MUX_A_out(A_BLOCK_out));
endmodule

module logic_MUX_A(rb,op,logic_MUX_A_out);
input [`OPCODE_WIDTH - 1 : 0] op;
input [`REGISTER_ADDR_WIDTH - 1: 0] rb;
output reg [1:0] logic_MUX_A_out;
always @* begin
if ((op == `OP_NEG) || (op == `OP_NOT))  
    logic_MUX_A_out = 2'b10;
else if (((op == `OP_LD) || (op == `OP_ST) || (op == `OP_LA)) && (rb == {`REGISTER_ADDR_WIDTH{1'b0}}))
    logic_MUX_A_out = 2'b10;
else if ((op == `OP_LDR) || (op == `OP_STR) || (op == `OP_LAR))
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
//////////////////////////////////////
//BLOCK B
module BLOCK_B(C1, C2, C3, Rrc_in, op, B_BLOCK_out);
input [`OPCODE_WIDTH - 1 : 0] op;
input [`Data_WIDTH - 1 : 0] Rrc_in;
input [`Data_WIDTH - 1 : 0] C1;
input [`Data_WIDTH - 1 : 0] C2;
input [$clog2(`Data_WIDTH) - 1 : 0] C3;
wire [`Data_WIDTH - 1 : 0] shift_amount;
wire [1:0] B_select;
output [`Data_WIDTH - 1 : 0] B_BLOCK_out;

logic_MUX_B logic_MUX_B_connect(.logic_MUX_B_out(B_select), .op(op));
shift_MUX_extended shift_MUX_extended_connect(.shift_amount(shift_amount), .C3_in(C3), .Rrc_shift(Rrc_in[$clog2(`Data_WIDTH) - 1 : 0]));
MUX_B MUX_BLOCK_A_connect(.MUX_B_select(B_select), .C1_in(C1), .C2_in(C2), .MUX_B_out(B_BLOCK_out), .Rrc_MUX_B_in(Rrc_in), .shift_amount(shift_amount));
endmodule

module shift_MUX_extended(Rrc_shift, C3_in, shift_amount);
input [$clog2(`Data_WIDTH) - 1 : 0] Rrc_shift;
input [$clog2(`Data_WIDTH) - 1 : 0] C3_in;
output [`Data_WIDTH - 1 : 0] shift_amount;
reg [$clog2(`Data_WIDTH) - 1 : 0] shift_MUX_out;
always @* begin
    case(C3_in == 0)
    1'b0: shift_MUX_out = C3_in;
    1'b1: shift_MUX_out = Rrc_shift;
    default: shift_MUX_out = C3_in;
    endcase
end
assign shift_amount = {{(`Data_WIDTH - $clog2(`Data_WIDTH)){1'b0}},shift_MUX_out};
endmodule


module logic_MUX_B(op, logic_MUX_B_out);
input [`OPCODE_WIDTH - 1 : 0] op;
output reg [1:0] logic_MUX_B_out;
always @* begin 
    if ((op == `OP_LDR) || (op == `OP_STR) || (op == `OP_LAR))
        logic_MUX_B_out = 2'b00; // C1
    else if ((op == `OP_LD) || (op == `OP_ST) || (op == `OP_LA) || (op == `OP_ADDI) || (op == `OP_ANDI) || (op == `OP_ORI) || (op == `OP_XORI) || (op == `OP_LTI) || (op == `OP_EQI))
        logic_MUX_B_out = 2'b01; // C2
    else if ((op == `OP_SHIFT_LEFT)|| (op == `OP_SHIFT_RIGHT) || (op == `OP_SHIFT_RIGHT_SIGN) || (op == `OP_SHIFT_CYCLE))
        logic_MUX_B_out = 2'b10; // shift
    else
        logic_MUX_B_out = 2'b11; // Rrc
end
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
        2'b00: MUX_B_out = C1_in;
        2'b01: MUX_B_out = C2_in;
        2'b10: MUX_B_out = shift_amount;
        2'b11: MUX_B_out = Rrc_MUX_B_in ;
        default: MUX_B_out = Rrc_MUX_B_in;
    endcase
end
endmodule

//////////////////////////////////////