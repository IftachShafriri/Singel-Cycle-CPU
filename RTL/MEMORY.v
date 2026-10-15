`include "Include/Opcodes.v"
`include "Include/DATA.v"

module MEMORY(PC_memory_in, instraction_out, MEM_address, MEM_enable_write, MEM_data_write, MEM_data_read, clk);
input [15 : 0] PC_memory_in ;
input MEM_enable_write, clk;
input [31:0] MEM_data_write, MEM_address;
wire [14:0] word_address;
wire valid_address;
output reg [31:0] MEM_data_read;
output [31 : 0] instraction_out;
reg [31 : 0] data_memory [0 : `MEMORY_DATA_SIZE - 1]; 
reg [31 : 0] instraction_memory [0 : `MEMORY_INSTRACTION_SIZE - 1]; 
assign word_address = MEM_address[16:2];
assign valid_address = (MEM_address[31:17] == 0);

initial begin
    $readmemh(`PROGRAM_FILE, instraction_memory);
end

initial begin
    $readmemh(`DATA_FILE, data_memory);
end


assign instraction_out = instraction_memory[PC_memory_in[15:2]];

// Reading data
always @* begin
    case (valid_address)
    1'b0 : MEM_data_read = 32'b0;
    1'b1 : MEM_data_read = data_memory[word_address];
    default : MEM_data_read = 32'b0;
    endcase
end


// Writing data 
always @(posedge clk) begin
    if (MEM_enable_write && valid_address)
        data_memory[word_address] <= MEM_data_write;
end


endmodule
