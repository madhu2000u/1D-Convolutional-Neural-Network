  module D_FF_28b(sum, f, clk, en_acc, clear_acc, reset, count);     
    input clk, en_acc, clear_acc,  reset;
    input signed [27:0] sum;
    output logic signed [27:0] f;
    // output logic valid_output;
    output logic [1:0] count;

    // parameter x = 6;
    // always_comb begin
    //     valid_output = 0;
    //     if(count == 3)
    //         valid_output = 1;
        
    // end

    always_ff @(posedge clk) begin
        if(reset || clear_acc) begin
            f <= 0;
            count <= 0;
        end
        else if(en_acc == 1) begin
            f <= sum;
            count <= count + 1;
        end
    end
endmodule

module D_FF_PipelineForAdders_28b(Input, Output, clk, reset, clear_reg, en_pipeline_reg); //Register used for pipelining
    input [27:0] Input;
    input clk, reset, clear_reg, en_pipeline_reg;
    output logic [27:0] Output;
    always_ff @(posedge clk) begin
        if (reset == 1 || clear_reg)
            Output <= 0;
        else if(en_pipeline_reg)
            Output <= Input;

    end
endmodule

module saturation_adder(a , b, sum_output);
    input [27:0] a, b;
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

    D_FF_PipelineForAdders_28b pipelineRegForAdders(sum, sum_output, clk, reset, clear_reg, en_pipeline_reg);
endmodule


module pipelined_adders(clk, reset, en_adders, clear_adders, mac_out_0, mac_out_1, mac_out_2, mac_out_3, mac_out_4, mac_out_5, mac_out_7, sum_lvl3_0);
    input clk, reset, en_acc, en_pipeline_reg, enable_mult, clear_acc, clear_reg, clear_pipeline_mult;
    input signed [13:0] a, b;
    input [27:0] mac_out_0, mac_out_1, mac_out_2, mac_out_3, mac_out_4, mac_out_5, mac_out_7;

    output logic [1:0] count;
    output logic signed [27:0] f;
    output logic signed [27:0] sum_lvl3_0;

    logic signed [27:0]  sum_lvl1_0, sum_lvl1_1, sum_lvl1_2, sum_lvl1_3, sum_lvl2_0, sum_lvl2_1;

    logic clr_rst_mpx;
    logic signed [27:0] pipelinedRegOut, pipelinedMultOut;


    saturation_adder adder0(mac_out_0, mac_out_1, sum_lvl1_0);
    saturation_adder adder1(mac_out_2, mac_out_3, sum_lvl1_1);
    saturation_adder adder2(mac_out_4, mac_out_5, sum_lvl1_2);
    saturation_adder adder3(mac_out_6, mac_out_7, sum_lvl1_3);
    saturation_adder adder4(sum_lvl1_1, sum_lvl1_2, sum_lvl2_0);
    saturation_adder adder5(sum_lvl1_3, sum_lvl1_4, sum_lvl2_1);
    saturation_adder adder6(sum_lvl2_1, sum_lvl2_2, sum_lvl3_0);


endmodule
