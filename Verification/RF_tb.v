`include "Include/Opcodes.v"
`include "Include/DATA.v"

module REGISTER_FILE_tb;
reg [$clog2(`Number_of_Registers) - 1 : 0] read_address1, read_address2, write_address;
reg  [`Data_WIDTH -1 : 0] data_write;
reg clk, enable_write, reset;
reg [`Data_WIDTH-1:0] expected_regs [0:63];
wire [`Data_WIDTH -1 : 0] data_read1, data_read2, data_read3;

REGISTER_FILE dut(.read_address1(read_address1),
            .read_address2(read_address2),
            .write_address(write_address),
            .data_write(data_write),
            .clk(clk),
            .enable_write(enable_write),
            .reset(reset),
            .data_read1(data_read1),
            .data_read2(data_read2),
            .data_read3(data_read3));
integer i;

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    $monitor("time = %0t, address1 = %0d, data1 = %0d, address2 = %0d, data2 = %0d, write_address =%0d, data3 = %0d",
    $time, read_address1, data_read1, read_address2, data_read2, write_address, data_read3);
end

initial begin
    // Writing to registers
    $display(" Writing to registers");
    reset = 1;
    enable_write = 0;
    #10;
    reset = 0;
    enable_write = 1;
    for (i = 0; i < 64 ; i = i + 1) begin
        write_address = i;
        data_write = $urandom_range(100,0);
        expected_regs[write_address] = data_write;
        @(posedge clk);
        #1;
    end
    
    enable_write = 0;
    for (i = 0; i < 64 ; i = i + 1) begin
        write_address = i;
        $display("registers[%0d] = %0d, expected_regs[%0d] = %0d", write_address, dut.registers[write_address], write_address, expected_regs[write_address]);
        if (expected_regs[write_address] == dut.registers[write_address])
            $display("register PASS the test %0d", write_address);
        else
            $display("register FAIL the test %0d", write_address);

    end
    #10;
    // Checking reading
    $display("Checking reading");
    for (i = 0; i < 10; i = i + 1) begin
        read_address1 = $urandom_range(63,0);
        read_address2 = $urandom_range(63,0);
        write_address = $urandom_range(63,0);
        #1;
    end
    #50;
    // Resets all registers
    $display("Resets all registers");
    reset = 1;
    @(posedge clk);
    #1;
    reset = 0;
    for (i = 0; i < 64 ; i = i + 1) begin
        $display("registers[%0d] = %0d", i, dut.registers[i]);
    end

    #5;

    // Checking if wirting even if enable == 0
    $display("Checking if wirting even if enable == 0");
    for (i = 0 ; i < 64 ; i = i + 1) begin
        write_address = i;
        data_write = $random;
        @(posedge clk);
        #1;
    end

/*    for (i = 0; i < 64 ; i = i + 1) begin
        $display("registers[%0d] = %0d", i, dut.registers[i]);
    end*/


$finish;
end

endmodule