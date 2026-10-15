`include "Include/Opcodes.v"
`include "Include/DATA.v"

module MAIN_CPU(clock, reset);
input clock, reset;
wire [5:0] Rc_address, Rb_address, Ra_address;
wire [31:0] Rra_data, Rrb_data, Rrc_data,
            MEM_data_read, ALU_result, RF_MUX_connect,
            ALU_DATA_A, ALU_DATA_B, instraction_coonect;
wire RF_enable_write, write_mux_select, MEM_enable_write;
wire [3:0] ALU_OP;
wire [15:0] PC_connect;
wire [1:0] PC_MUX_connect;

// ALU CONNECTING
ALU ALU_CONNECTING(.y(ALU_result), .a(ALU_DATA_A),
            .b(ALU_DATA_B), .ALU_OP(ALU_OP));

// CONTROL CONNECTING
CONTROL_BLOCK CONTROL_CONNECTING(.Ra(Ra_address),
            .Rb(Rb_address), .Rc(Rc_address),
            .INSTRUCTION(instraction_coonect),
            .Rrb_in(Rrb_data), .Rrc_in(Rrc_data),
            .write_MUX_select(write_mux_select),
            .MEM_enable_write(MEM_enable_write),
            .RF_enable_write(RF_enable_write),
            .ALU_OP(ALU_OP),
            .ALU_A_in(ALU_DATA_A), .ALU_B_in(ALU_DATA_B),
            .PC_select_out(PC_MUX_connect), .PC(PC_connect));

//MUX REGISTER FILE CONNECT
MUX_RF_Write MUX_RF_CONNECTING(.ALU_result(ALU_result),
            .write_mux_select(write_mux_select),
            .RF_data_in(RF_MUX_connect),
            .memory_data(MEM_data_read));

// RF CONNECTING
REGISTER_FILE RF_CONNECTING(.data_write(RF_MUX_connect),
            .write_address(Ra_address), .enable_write(RF_enable_write),
            .data_read1(Rrb_data), .data_read2(Rrc_data), .data_read3(Rra_data),
            .read_address1(Rb_address), .read_address2(Rc_address),
            .clk(clock), .reset(reset));


// MEMORY CONNECTING 
MEMORY MEMORY_CONNECTING(.MEM_data_write(Rra_data), .MEM_address(ALU_result),
            .instraction_out(instraction_coonect),
            .clk(clock), .PC_memory_in(PC_connect),
            .MEM_enable_write(MEM_enable_write),
            .MEM_data_read(MEM_data_read));


// PC CONNECTING
PC PC_CONNECTING(.clock(clock), .reset(reset),
            .PC_out(PC_connect), .select(PC_MUX_connect),
            .constant(instraction_coonect[15:0]));

endmodule

module MUX_RF_Write(write_mux_select, memory_data, ALU_result, RF_data_in );
input write_mux_select;
input [31:0] memory_data, ALU_result;
output [31:0] RF_data_in;
assign RF_data_in = write_mux_select ? memory_data : ALU_result;
endmodule

