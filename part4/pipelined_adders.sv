module D_FF_PipelineForAdders_28b(Input, Output, clk, reset); //Register used for pipelining
    input [27:0] Input;
    input clk, reset;
    output logic [27:0] Output;
    always_ff @(posedge clk) begin
        if (reset)
            Output <= 0;
        else
            Output <= Input;

    end
endmodule

module saturation_adder(clk, reset, a, b, sum_output);
    input [27:0] a, b;
    input clk, reset;
    output [27:0] sum_output;

    logic signed [27:0] sum;
    logic [27:0] MIN_VALUE, MAX_VALUE;
    assign MAX_VALUE = 28'h7ffffff;
    assign MIN_VALUE = 28'h8000000;

    always_comb begin
        sum = a + b;        
        if(a[27] && b[27] && ~sum[27]) begin
             sum = MIN_VALUE;  
         end
         else if(~a[27] && ~b[27] && sum[27]) begin
             sum = MAX_VALUE;
         end
    end

    D_FF_PipelineForAdders_28b pipelineRegForAdders(sum, sum_output, clk, reset);
endmodule


module pipelined_adders(clk, reset, mac_out_0, mac_out_1, mac_out_2, mac_out_3, mac_out_4, mac_out_5, mac_out_6, mac_out_7, sum_lvl3_0);
    input clk, reset;
    input signed [27:0] mac_out_0, mac_out_1, mac_out_2, mac_out_3, mac_out_4, mac_out_5, mac_out_6, mac_out_7;
    output logic signed [27:0] sum_lvl3_0;

    logic signed [27:0] sum_lvl1_0, sum_lvl1_1, sum_lvl1_2, sum_lvl1_3, sum_lvl2_0, sum_lvl2_1;

    saturation_adder adder0(clk, reset, mac_out_0, mac_out_1, sum_lvl1_0);
    saturation_adder adder1(clk, reset, mac_out_2, mac_out_3, sum_lvl1_1);
    saturation_adder adder2(clk, reset, mac_out_4, mac_out_5, sum_lvl1_2);
    saturation_adder adder3(clk, reset, mac_out_6, mac_out_7, sum_lvl1_3);
    saturation_adder adder4(clk, reset, sum_lvl1_0, sum_lvl1_1, sum_lvl2_0);
    saturation_adder adder5(clk, reset, sum_lvl1_2, sum_lvl1_3, sum_lvl2_1);
    saturation_adder adder6(clk, reset, sum_lvl2_0, sum_lvl2_1, sum_lvl3_0);


endmodule
