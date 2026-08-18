`include "Include/DATA.v"

module Register_File #(parameter Num_of_Registers = `Number_of_Registers, parameter Register_Size_Bit = `Data_WIDTH) //Setting the size of register and the number of registers
    (data_read1,
    data_read2,
    read_addres1,
    read_addres2,
    data_write,
    write_addres,
    enable_write,
    clk,
    reset);

reg [Register_Size_Bit - 1 : 0] registers [Num_of_Registers -1 : 0];
input [$clog2(Num_of_Registers) - 1 : 0] read_addres1, read_addres2, write_addres;
input [Register_Size_Bit -1 : 0] data_write;
input clk, enable_write, reset;
output [Register_Size_Bit -1 : 0] data_read1, data_read2;

assign data_read1 = registers[read_addres1];
assign data_read2 = registers[read_addres2];

integer i;

always @(posedge clk) begin
    if (reset)
        for (i = 0; i < Num_of_Registers; i = i + 1)
            registers[i] <= {Register_Size_Bit{1'b0}};

    else if (enable_write)
        registers[write_addres] <= data_write;

end
endmodule