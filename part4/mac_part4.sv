
module D_FF_PipelineReg_28b(regProdIn, regProdOut, clk, reset); //Register used for pipelining
    input signed [27:0] regProdIn;
    input clk, reset;
    output logic signed [27:0] regProdOut;
    always_ff @(posedge clk) begin
        if (reset)
            regProdOut <= 0;
        else
            regProdOut <= regProdIn;

    end
endmodule

module mac_part4(clk, reset, enable_mult, clear_pipeline_mult, a, b, pipelinedRegOut);
    input clk, reset, enable_mult, clear_pipeline_mult;
    input signed [13:0] a, b;

    output logic signed [27:0] pipelinedRegOut;
    logic clr_rst_mpx;
    logic signed [27:0] pipelinedMultOut;

    parameter multPipelinedStages = 2;
    parameter integer WIDTH = 14;  
    
    always_comb begin
        clr_rst_mpx = reset ? reset : clear_pipeline_mult;
    end

    DW_mult_pipe #(WIDTH, WIDTH, multPipelinedStages, 1, 2) pipelinedMultiplier(clk, ~clr_rst_mpx, enable_mult, 1'b1, a, b, pipelinedMultOut);
    D_FF_PipelineReg_28b pipelineReg(pipelinedMultOut, pipelinedRegOut, clk, reset);
    

endmodule
