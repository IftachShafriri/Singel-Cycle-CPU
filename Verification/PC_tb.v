`include "Include/Opcodes.v"
`include "Include/DATA.v"

module PC_tb();
reg clock, reset;
reg [1:0] select;
reg [`PC_WIDTH - 1 : 0] constant;
wire [`PC_WIDTH -1 : 0]  PC_out;

PC dut(.clock(clock),
        .reset(reset),
        .select(select),
        .constant(constant),
        .PC_out(PC_out));

initial begin
    clock = 0;
    forever #5 clock = ~clock;
end

initial begin
    $monitor("time = %0t, current_PC = %0d, next_PC = %0d, reset_status = %0b",
    $time, PC_out, dut.register_wire_connect, reset);
end
integer i;

initial begin
    // Reseting the PC
    select = 2'b00;
    constant = 0;
    reset = 1;
    @(posedge clock);
    #1;
    reset =0; 
    #1;
    for (i = 0; i < 10; i = i + 1) begin
        select = 2'b00;
        constant = 0;
        @(posedge clock);
    #1;
    end
    $display(" mark");

    constant = 16'b1111110101010100;
    select = 2'b10;
    @(posedge clock);


    #1; 
    $finish;
end
endmodule