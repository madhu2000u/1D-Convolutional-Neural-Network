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


module part4b_mac(clk, reset, en_acc, en_pipeline_reg, enable_mult, clear_acc, clear_reg, a, b, f, count);
    input clk, reset, en_acc, en_pipeline_reg, enable_mult, clear_acc, clear_reg;
    input signed [13:0] a, b;

    output logic [1:0] count;
    output logic signed [27:0] f;
    // output logic valid_output;
    logic signed [27:0] prod, sum;
    //logic en_acc;
    logic signed [27:0] pipelinedRegOut, pipelinedMultOut;
    //logic signed [13:0] q1,q2;

    parameter multPipelinedStages = 2;
    parameter integer WIDTH = 14;

    // The parameter for the below Controller module specifies the number of multiplier stages required. Note: multPipelinedStages variable should match with the parameter passed to Controller
   //Controller #(2) controller(.clk(clk), .valid_in(valid_in), .enable_ab(enable_ab), .enable_f(enable_f), .valid_out(valid_out), .reset(reset));
    //D_FF_13b D1(a,q1,clk,enable_ab, reset);
    //D_FF_13b D2(b,q2,clk,enable_ab, reset); 

    logic [27:0] MIN_VALUE, MAX_VALUE;
    assign MAX_VALUE = 28'h7ffffff;
    assign MIN_VALUE = 28'h8000000;  

    // always_ff @( posedge clk ) begin
    //     en_acc <= en_acc;
        
    // end

    
    always_comb begin
        //prod = a * b;
        sum = pipelinedRegOut + f;        
        if(pipelinedRegOut[27] && f[27] && ~sum[27]) begin
            sum = MIN_VALUE;  
        end
        else if(~pipelinedRegOut[27] && ~f[27] && sum[27]) begin
            sum = MAX_VALUE;
        end
        
    end

    DW_mult_pipe #(WIDTH, WIDTH, multPipelinedStages, 1, 2) pipelinedMultiplier(clk, ~reset, enable_mult, 1'b1, b, a, pipelinedMultOut); 

    
    D_FF_PipelineReg_28b pipelineReg(pipelinedMultOut, pipelinedRegOut, clk, reset, clear_reg, en_pipeline_reg);
    D_FF_28b D_FF_28b(sum, f, clk, en_acc, clear_acc, reset, count);

endmodule
