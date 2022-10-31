module Counter(clk, reset, clear, enable, countOut);
    parameter WIDTH = 4;
    input clk, reset, clear, enable;
    logic [WIDTH-1:0] countIn;
    output logic [WIDTH-1:0]countOut;


    always_ff @( posedge clk ) begin
        if(reset || clear)
            countOut <= 0;
        else if(enable) begin
            countOut <= countOut + 1;
        end        
    end
    
    
endmodule

module Controller(clk, reset, input_valid, new_matrix, output_ready, addr_x, wr_en_x, addr_w, wr_en_w, clear_acc, en_acc, en_pipeline_reg, enable_mult, input_ready, output_valid, output_data);

    parameter ADDR_X_SIZE = 2;
    parameter ADDR_W_SIZE = 4;
    parameter WIDTH_MEM_READ_X = 2;         
    parameter WIDTH_MEM_READ_W = 4;         
    parameter WIDTH_MAC = 4;                

    parameter matrixSize = 3;
    parameter delay_pipeline_n = 4;
    parameter pipelineStages = 0;
    parameter enable_pipeline_reg_after_initial_delay = pipelineStages + 1;
    parameter enable_acc_after_initial_delay = enable_pipeline_reg_after_initial_delay + 1;

    input clk, reset, input_valid, new_matrix, output_ready;
    output logic input_ready, output_valid;
    input logic signed [27:0] output_data;

    output logic [ADDR_X_SIZE-1:0] addr_x;  
    output logic [ADDR_W_SIZE-1:0] addr_w;
    output logic wr_en_x, wr_en_w, clear_acc, en_acc, en_pipeline_reg, enable_mult;    

    logic countMemState;                                        //0 -> state that tells we are writing to matrix, 1 -> state that tells we are writing to vector     
    logic operationState;                                       //0 -> writing state, 1 -> reading/execution state  

    logic clear_cntrMac, enable_cntrMac;             
    logic clear_cntrMemX, enable_cntrReadMem_X;      
    logic clear_cntrMemW, enable_cntrReadMem_W;      

    logic [WIDTH_MAC-1:0] countMacOut;
    logic [WIDTH_MEM_READ_X-1:0] countMem_X_Out;
    logic [WIDTH_MEM_READ_W-1:0] countMem_W_Out;


    always_ff @( posedge clk ) begin
        if(reset) begin
            output_valid <= 0;
            enable_mult <= 0;
            en_acc <= 0;
            en_pipeline_reg <= 0;
            countMemState <= 0;
            operationState <= 0;
            
        end

        if((countMacOut == (delay_pipeline_n) || countMacOut == (delay_pipeline_n + matrixSize) || countMacOut == (delay_pipeline_n + 2 * matrixSize)) && ~clear_acc) begin         //When output is valid, stall execution by disabling all multipliers, registers and accumulators until output_ready is asserted and value is sampled (check reference #1)
            output_valid <= 1;
            enable_mult <= 0;
            en_acc <= 0;
            en_pipeline_reg <= 0;
        end
        
        if(countMacOut == enable_pipeline_reg_after_initial_delay) begin        //enable the pipeline register after this delay to pass through a valid value
            en_pipeline_reg <= 1;
        end

        if(countMacOut == enable_acc_after_initial_delay) begin                 //enable the accumulator after this delay to pass through a valid value
            en_acc <= 1;
        end       
        

        if(clear_acc && countMacOut != (delay_pipeline_n + 2 * matrixSize)) begin       //When cleac_acc is asserted(by another part of the control logic (check reference #1)), it implies output data was sampled and we can un-stall the execution
            enable_mult <= 1;
            en_acc <= 1;
            en_pipeline_reg <= 1;

        end

        if(~operationState) begin       //Disable execution when we switch to writing state
            enable_mult <= 0;
            en_acc <= 0;
            en_pipeline_reg <= 0;
        end

        if(output_valid && output_ready) begin      //(reference #1). On posedge when output_valid and output_ready is asserted, the valid data is sampled and we clear the accumulator and de-assert output_valid
            clear_acc <= 1;
            output_valid <= 0;
        end
        else 
            clear_acc <= 0;

        if(~operationState) begin           //when in write mode, we are ready to take in new input
            if(new_matrix || ~new_matrix)   //We are ready only once we know the value of new_matrix
                input_ready <= 1;
            
            clear_cntrMemW <= 0;

            if(input_valid) begin
                if(~countMemState && countMem_W_Out == 8) begin     //we are writing to matrix, once written switch state to vector
                    countMemState <= 1;
                end
                else if(countMemState && countMem_X_Out == 2) begin     //we are writing to vector, once written switch state back to matrix and also switch state to execution state (operationState = 1)
                    input_ready <= 0;
                    countMemState <= 0;
                    operationState <= 1;
                    clear_cntrMemW <= 1;
                    clear_cntrMac <= 1;
                    enable_mult <= 1;
                end
            end
            
            if(new_matrix) begin        //if new_matrix, then we are in write to matrix state
                countMemState <= 0;
            end
            else if(~new_matrix) begin
                countMemState <= 1;     //if no new_matrix, then we switch to writing to vector
            end
            
            
        end
        else if(operationState) begin   //read/execution state
            clear_cntrMemW <= 0;
            clear_cntrMac <= 0;

            if(countMacOut == (delay_pipeline_n + 2 * matrixSize) && clear_acc) begin   //we have the final value of matrix at this delay and waiting for clear_acc to be asserted once value is sampled and then we switch to write mode
                clear_cntrMac <= 1;
                clear_cntrMemW <= 1;
                operationState <= 0;
            end
        end
        
    end


    always_comb begin
        addr_w = countMem_W_Out;
        addr_x = countMem_X_Out;

        wr_en_x = 0;
        wr_en_w = 0;
        enable_cntrReadMem_X = 0;
        enable_cntrReadMem_W = 0;
        enable_cntrMac = 0;
        if(operationState) begin    //read mode
            wr_en_w = input_ready;
            wr_en_x = input_ready;
            enable_cntrReadMem_X = ~output_valid;
            enable_cntrReadMem_W = ~output_valid;
            enable_cntrMac = ~output_valid;

            if((countMacOut == (delay_pipeline_n) || countMacOut == (delay_pipeline_n + matrixSize) || countMacOut == (delay_pipeline_n + 2 * matrixSize)) && ~clear_acc) begin         //Stall address and delay counters when output_valid
                enable_cntrReadMem_X = 0;
                enable_cntrReadMem_W = 0;
                enable_cntrMac = 0;

            end

            clear_cntrMemX = (countMem_X_Out == 2) && (enable_cntrReadMem_X) ? 1 : 0;       //clear vector counter after count 2 as we don't have any value at address 3

            
        end
        else begin              //write mode
            
            enable_cntrMac = 0;
            clear_cntrMemX = (countMem_X_Out == 3) || (countMacOut == (delay_pipeline_n + 2 * matrixSize) + 1) ? 1 : 0;



            if((~countMemState && ~input_valid) || (countMemState && ~input_valid)) begin
                enable_cntrReadMem_X = input_valid;
                enable_cntrReadMem_W = input_valid;

                wr_en_x = input_valid;
                wr_en_w = input_valid;
            end

            if(~countMemState && input_valid) begin
                enable_cntrReadMem_X = 0;
                enable_cntrReadMem_W = input_ready;
                
                wr_en_x = 0;
                wr_en_w = input_ready;
                
            end
            else if(countMemState && input_valid) begin
                enable_cntrReadMem_X = input_ready;
                enable_cntrReadMem_W = 0;

                wr_en_x = input_ready;
                wr_en_w = 0;
                
            end
        end
            
    end

    Counter #(WIDTH_MAC) cntrMac (clk, reset, clear_cntrMac, enable_cntrMac, countMacOut);
    Counter #(WIDTH_MEM_READ_X) cntrMemX (clk, reset, clear_cntrMemX, enable_cntrReadMem_X, countMem_X_Out);
    Counter #(WIDTH_MEM_READ_W) cntrMemW (clk, reset, clear_cntrMemW, enable_cntrReadMem_W, countMem_W_Out);

endmodule



module matvec3_part2(clk, reset, input_valid, input_ready, input_data, new_matrix, output_valid, output_ready, output_data);
    parameter SIZE_X = 3;
    parameter SIZE_W = 9;
    parameter WIDTH = 14;
    parameter pipelineStages = 7;
    parameter matrixSize = 3;                   //Number of columns
    parameter d0 = 3;                           //Base delay(including the pipeline register) when multiplier pipeline stages is 0.

    parameter WIDTH_MEM_READ_X = 2;             //Width of counter that writes to memory and reads from memory X (cntrMemX).
    parameter WIDTH_MEM_READ_W = 4;             //Width of counter that writes to memory and reads from memory W (cntrMemW).
    parameter WIDTH_MAC = 5;                    //Width of counter that calculates execution delay

    localparam delay_pipeline_n = d0 + pipelineStages;                                              //delay to get the first row's output.
    localparam enable_pipeline_reg_after_initial_delay = pipelineStages - 1;                        //The delay after with the pipeline register must be enabled in order to not propagate 'x'/junk values into it
    localparam enable_acc_after_initial_delay = enable_pipeline_reg_after_initial_delay + 1;        //The delay after which the accumulator must be enabled in order to not propage 'x'/junk values into it

    localparam ADDR_X_SIZE = $clog2(SIZE_X);
    localparam ADDR_W_SIZE = $clog2(SIZE_W);

    input clk, reset, input_valid, new_matrix, output_ready;
    input signed [13:0] input_data;

    logic signed [13:0] vectorMem_data_out, matrixMem_data_out;
    logic [ADDR_X_SIZE-1:0] addr_x;
    logic [ADDR_W_SIZE-1:0] addr_w;
    logic wr_en_x, wr_en_w;
    logic clear_acc, en_acc, en_pipeline_reg, enable_mult;


    output logic signed [27:0] output_data;
    output logic output_valid, input_ready;

    Controller #(ADDR_X_SIZE, ADDR_W_SIZE, WIDTH_MEM_READ_X, WIDTH_MEM_READ_W, WIDTH_MAC, matrixSize, delay_pipeline_n, pipelineStages, enable_pipeline_reg_after_initial_delay, enable_acc_after_initial_delay) controller(clk, reset, input_valid, new_matrix, output_ready, addr_x, wr_en_x, addr_w, wr_en_w, clear_acc, en_acc, en_pipeline_reg, enable_mult, input_ready, output_valid, output_data);

    memory #(WIDTH, SIZE_X) vectorMem(clk, input_data, vectorMem_data_out, addr_x, wr_en_x );
    memory  #(WIDTH, SIZE_W) matrixMem(clk, input_data, matrixMem_data_out, addr_w, wr_en_w);

    mac_part2 #(pipelineStages, WIDTH) macUnit(clk, reset, en_acc, en_pipeline_reg, enable_mult, clear_acc, vectorMem_data_out, matrixMem_data_out, output_data);

endmodule