module output_memory(clk, data_in, data_out, wr_addr, rd_addr, wr_en);
   
    parameter                   WIDTH=16, SIZE=64;
    localparam                  LOGSIZE=$clog2(SIZE);
    input [WIDTH-1:0]           data_in;
    output logic [WIDTH-1:0]    data_out;
    input [LOGSIZE-1:0]         wr_addr;
    input [LOGSIZE-1:0]         rd_addr;
    input                       clk, wr_en;
    
    logic [SIZE-1:0][WIDTH-1:0] mem;
    assign data_out = mem[rd_addr];
    always_ff @(posedge clk) begin
        if (wr_en)
            mem[wr_addr] <= data_in;
    end
endmodule
