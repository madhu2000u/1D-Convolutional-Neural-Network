module D_FF_13b(d, q, clk, enable_ab, reset);
    input [13:0] d;
    input clk, reset, enable_ab;
    output logic [13:0] q;
    always_ff @(posedge clk) begin
        if (reset == 1)
            q <= 0;
        else if(enable_ab == 1)
            q <= d;

    end
endmodule

module D_FF_PipelineReg_28b(regProdIn, regProdOut, clk, reset, clear_reg, en_pipeline_reg); //Register used for pipelining
    input [27:0] regProdIn;
    input clk, reset, clear_reg, en_pipeline_reg;
    output logic [27:0] regProdOut;
    always_ff @(posedge clk) begin
        if (reset == 1 || clear_reg)
            regProdOut <= 0;
        else if(en_pipeline_reg)
            regProdOut <= regProdIn;

    end
endmodule

module mac_part4(clk, reset, en_acc, en_pipeline_reg, enable_mult, clear_acc, clear_reg, clear_pipeline_mult, a, b, pipelinedRegOut, count);
    input clk, reset, en_acc, en_pipeline_reg, enable_mult, clear_acc, clear_reg, clear_pipeline_mult;
    input signed [13:0] a, b;

    output logic [1:0] count;
    output logic signed [27:0] pipelinedRegOut;
    //logic signed [27:0] mac_out_0, mac_out_1, mac_out_2, mac_out_3, mac_out_4, mac_out_5, mac_out_7;
    logic signed [27:0] sum_lvl1_1, sum_lvl1_2, sum_lvl1_3, sum_lvl1_4, sum_lvl2_1, sum_lvl2_2, sum_lvl3_1 
    logic clr_rst_mpx;
    logic signed [27:0] pipelinedMultOut;

    parameter multPipelinedStages = 2;
    parameter integer WIDTH = 14;



    logic [27:0] MIN_VALUE, MAX_VALUE;
    assign MAX_VALUE = 28'h7ffffff;
    assign MIN_VALUE = 28'h8000000;  
    
    always_comb begin
        clr_rst_mpx = reset ? reset : clear_pipeline_mult;
    end

    DW_mult_pipe #(WIDTH, WIDTH, multPipelinedStages, 1, 2) pipelinedMultiplier(clk, ~clr_rst_mpx, enable_mult, 1'b1, a, b, pipelinedMultOut);
    D_FF_PipelineReg_28b pipelineReg(pipelinedMultOut, pipelinedRegOut, clk, reset, clear_reg, en_pipeline_reg);
    
    //D_FF_28b D_FF_28b(sum, f, clk, en_acc, clear_acc, reset, count);

endmodule
