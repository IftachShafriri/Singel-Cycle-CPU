module Register_File #(parameter Num_of_Registers = 64, parameter Register_Size_Bit = 4 ) 
    (data_read1,
    data_read2,
    read_addr1,
    read_addr2,
    data_write,
    write_addr,
    enable_write,
    clk,
    reset)