module Counter(clk, reset, clear, enable, countOut);
    parameter WIDTH = 4;
    input clk, reset, clear, enable;
    logic [WIDTH-1:0] countIn;
    output logic [WIDTH-1:0]countOut;


    always_ff @( posedge clk ) begin
        if(reset || clear)
            countOut <= 0;
        else if(enable) begin
            // if(countOut == 2) begin
            //     countOut <= 0;
            // end
            countOut <= countOut + 1;
        end        
    end
    
    
endmodule

module Controller(clk, reset, input_valid, new_matrix, output_ready, addr_x, 
    wr_en_x_g1_0, wr_en_x_g1_1, wr_en_x_g1_2, wr_en_x_g1_3, wr_en_x_g1_4, wr_en_x_g1_5, wr_en_x_g1_6, wr_en_x_g1_7,
    // wr_en_x_g2_0, wr_en_x_g2_1, wr_en_x_g2_2, wr_en_x_g2_3, wr_en_x_g2_4, wr_en_x_g2_5, wr_en_x_g2_6, wr_en_x_g2_7, 
    addr_w, 
    wr_en_w_g1_0, wr_en_w_g1_1, wr_en_w_g1_2, wr_en_w_g1_3, wr_en_w_g1_4, wr_en_w_g1_5, wr_en_w_g1_6, wr_en_w_g1_7, 
    // wr_en_w_g2_0, wr_en_w_g2_1, wr_en_w_g2_2, wr_en_w_g2_3, wr_en_w_g2_4, wr_en_w_g2_5, wr_en_w_g2_6, wr_en_w_g2_7, 
    clear_pipeline_multiplier, clear_acc, clear_reg, en_acc, en_pipeline_reg, enable_mult, input_ready, output_valid, count, output_data);

    parameter ADDR_X_SIZE = 2;
    parameter ADDR_W_SIZE = 4;
    parameter WIDTH_MEM_READ_X = 2;         //Size of counter that writes to memory and reads from memory X (cntrMemX)
    parameter WIDTH_MEM_READ_W = 4;         //Size of counter that writes to memory and reads from memory W (cntrWriteMemW)
    parameter WIDTH_MAC = 4;                //Size of counter that handles MAC delay(cntrMac)
    parameter WIDTH_MEM_BANK_CNTR = 8;

    parameter matrixSize = 3;
    parameter delay_pipeline_n = 4;
    parameter pipelineStages = 0;
    parameter enable_pipeline_reg_after_initial_delay = pipelineStages + 1;
    parameter enable_acc_after_initial_delay = enable_pipeline_reg_after_initial_delay + 1;

    input clk, reset, input_valid, new_matrix, output_ready;
    input [1:0] count;
    output logic input_ready, output_valid;
    input logic signed [27:0] output_data;

    output logic [ADDR_X_SIZE-1:0] addr_x;  
    output logic [ADDR_W_SIZE-1:0] addr_w;
    output logic wr_en_x_g1_0, wr_en_x_g1_1, wr_en_x_g1_2, wr_en_x_g1_3, wr_en_x_g1_4, wr_en_x_g1_5, wr_en_x_g1_6, wr_en_x_g1_7;
    output logic wr_en_w_g1_0, wr_en_w_g1_1, wr_en_w_g1_2, wr_en_w_g1_3, wr_en_w_g1_4, wr_en_w_g1_5, wr_en_w_g1_6, wr_en_w_g1_7;
    output logic clear_acc, clear_pipeline_multiplier, clear_reg, en_acc, en_pipeline_reg, enable_mult;    

    logic countMemState;        //State that keeps track of weather the counter is outputting addresses for the matrix memory or the vector memory.     
    logic operationState;   //0 -> writing state, 1 -> reading state
    logic valid_out_internal;

    logic clear_cntrMem, enable_cntrWriteMem;        //Counter that handles (produces addresses) to write to both memories
    logic clear_cntrMac, enable_cntrMac;             //Counter that handles delay in MAC arithmetic for output_valid signals just for initial stages until the pipeline if full
    //logic clear_cntrMemX, enable_cntrReadMem_X;      //Counter that handles (produces addresses) to read from vector memory (X)
    logic clear_cntrWriteMemW, enable_cntrReadMem_W;      //Counter that handles (produces addresses) to read from matrix memory (W)
    logic clear_cntrMemBank, enable_cntrMemBank;

    logic [WIDTH_MEM_READ_W-1:0] countMemOut, countMemOutDelay;
    logic [WIDTH_MAC-1:0] countMacOut;
    logic [WIDTH_MEM_READ_X-1:0] countMem_X_Out;
    logic [WIDTH_MEM_READ_W-1:0] countWriteMem_W_Out;
    logic [WIDTH_MEM_BANK_CNTR-1:0] countMemBankOut;


    always_ff @( posedge clk ) begin
        if(reset) begin
            output_valid <= 0;
            enable_mult <= 0;
            en_acc <= 0;
            en_pipeline_reg <= 0;

            //new
            countMemState <= 0;
            operationState <= 0;
            //new
            
        end

        if((countMacOut == (delay_pipeline_n + 0 * matrixSize) || countMacOut == (delay_pipeline_n + 1 * matrixSize) || countMacOut == (delay_pipeline_n + 2 * matrixSize) || 
            countMacOut == (delay_pipeline_n + 3 * matrixSize) || countMacOut == (delay_pipeline_n + 4 * matrixSize) || countMacOut == (delay_pipeline_n + 5 * matrixSize) || 
            countMacOut == (delay_pipeline_n + 6 * matrixSize) || countMacOut == (delay_pipeline_n + 7 * matrixSize)) && ~clear_acc) begin

            output_valid <= 1;
            enable_mult <= 0;
            en_acc <= 0;
            en_pipeline_reg <= 0;
        end
        
        if(countMacOut == enable_pipeline_reg_after_initial_delay) begin
            en_pipeline_reg <= 1;
        end

        if(countMacOut == enable_acc_after_initial_delay) begin
            en_acc <= 1;
        end       
        

        if(clear_acc && countMacOut != (delay_pipeline_n + 7 * matrixSize)) begin
            enable_mult <= 1;
            en_acc <= 1;
            en_pipeline_reg <= 1;

        end

        if(~operationState) begin
            enable_mult <= 0;
            en_acc <= 0;
            en_pipeline_reg <= 0;
        end

        if(output_valid && output_ready) begin
            clear_acc <= 1;
            output_valid <= 0;
        end
        else 
            clear_acc <= 0;

        //code from the below ff
        if(~operationState) begin
            // addr_w <= countWriteMem_W_Out;
            // addr_x <= countMem_X_Out;
            if(new_matrix || ~new_matrix)
                input_ready <= 1;
            //clear_cntrMem <= 0;
            //clear_cntrMemX <= 0;
            clear_cntrWriteMemW <= 0;

            if(input_valid) begin
                if(~countMemState && countWriteMem_W_Out == 7 && countMemBankOut == 7) begin
                    //input_ready <= 0;
                    //clear_cntrMem <= 1;
                    countMemState <= 1;
                end
                else if(countMemState && countMemBankOut == 7) begin
                    input_ready <= 0;
                    //clearcntmem <= 0;
                    countMemState <= 0;
                    operationState <= 1;
                    //clear_cntrMemX <= 1;
                    //clear_cntrWriteMemW <= 1;
                    clear_cntrMac <= 0;
                    enable_mult <= 1;
                end
            end
            
            if(new_matrix) begin
                countMemState <= 0;
            end
            else if(~new_matrix) begin
                countMemState <= 1;
            end
            
            
        end
        else if(operationState) begin
            // addr_x = countMem_X_Out;
            // addr_w = countWriteMem_W_Out;
            //clear_cntrMemX <= (countMem_X_Out == 1) ? 1 : 0;
            clear_cntrWriteMemW <= 0;
            clear_cntrMac <= 0;
            clear_reg <= 0;
            clear_pipeline_multiplier <= 0;

            if(countMacOut == (delay_pipeline_n + 7 * matrixSize)) begin
                clear_reg <= 1;
                clear_pipeline_multiplier <= 1;
                if(clear_acc) begin
                    clear_cntrMac <= 1;
                    clear_cntrWriteMemW <= 1;
                    operationState <= 0;
                end
            end

            // if(countMacOut == (matrixSize * matrixSize) - 1)
            //     clear_cntrWriteMemW <= 1;
        end
        
    end


    always_comb begin
        //enable_cntrWriteMem = input_ready;
        addr_w = countWriteMem_W_Out;
        //addr_x = countMem_X_Out;

        //enable_cntrReadMem_X = 0;
        enable_cntrReadMem_W = 0;
        enable_cntrMac = 0;
        if(operationState) begin    //read mode
            wr_en_w = input_ready;
            wr_en_x = input_ready;

            
            //enable_cntrReadMem_X = (countMem_X_Out == (matrixSize * matrixSize) - 1) ? 0 : ~output_valid;;
            enable_cntrReadMem_W = (countWriteMem_W_Out == (matrixSize * matrixSize) - 1) ? 0 : ~output_valid;
            enable_cntrMac = ~output_valid;

            if((countMacOut == (delay_pipeline_n + 0 * matrixSize) || countMacOut == (delay_pipeline_n + 1 * matrixSize) || countMacOut == (delay_pipeline_n + 2 * matrixSize) || 
            countMacOut == (delay_pipeline_n + 3 * matrixSize) || countMacOut == (delay_pipeline_n + 4 * matrixSize) || countMacOut == (delay_pipeline_n + 5 * matrixSize) || 
            countMacOut == (delay_pipeline_n + 6 * matrixSize) || countMacOut == (delay_pipeline_n + 7 * matrixSize)) && ~clear_acc) begin

                //enable_cntrReadMem_X = 0;
                enable_cntrReadMem_W = 0;
                enable_cntrMac = 0;

            end

            //clear_cntrMemX = (countMem_X_Out == 7) && (enable_cntrReadMem_X) ? 1 : 0;

            // if(countMacOut == 11) begin
            //     clear_cntrMemX = 1;
            // end
            // else begin
            //     clear_cntrMemX = 0;
            // end
            
        end
        else begin              //write mode
            
            enable_cntrMac = 0;
            clear_cntrMemX = 0;
            //wr_en_w = 0;
            // if(countMem_X_Out == 3)
            //     clear_cntrMemX = 1;
            // else
            //     clear_cntrMemX = 0;
            
            //clear_cntrMemX = (countMem_X_Out == 7) || (countMacOut == (delay_pipeline_n + 7 * matrixSize) + 1) ? 1 : 0;



            if((~countMemState && ~input_valid) || (countMemState && ~input_valid)) begin
                //enable_cntrReadMem_X = input_valid;
                enable_cntrReadMem_W = input_valid;

                wr_en_x_g1_0 = 0; 
                wr_en_x_g1_1 = 0;
                wr_en_x_g1_2 = 0;
                wr_en_x_g1_3 = 0;
                wr_en_x_g1_4 = 0;
                wr_en_x_g1_5 = 0;
                wr_en_x_g1_6 = 0;
                wr_en_x_g1_7 = 0;


                wr_en_w_g1_0 = 0;
                wr_en_w_g1_1 = 0;
                wr_en_w_g1_2 = 0;
                wr_en_w_g1_3 = 0;
                wr_en_w_g1_4 = 0; 
                wr_en_w_g1_5 = 0; 
                wr_en_w_g1_6 = 0; 
                wr_en_w_g1_7 = 0; 
            end

            if(~countMemState && input_valid) begin
                //enable_cntrReadMem_X = 0;
                //enable_cntrReadMem_W = input_ready;
                enable_cntrMemBank = input_ready;

                if(countMemBankOut == 7)
                    enable_cntrReadMem_W = input_ready;
                else
                    enable_cntrReadMem_W = 0;

                wr_en_x_g1_0 = 0; 
                wr_en_x_g1_1 = 0;
                wr_en_x_g1_2 = 0;
                wr_en_x_g1_3 = 0;
                wr_en_x_g1_4 = 0;
                wr_en_x_g1_5 = 0;
                wr_en_x_g1_6 = 0;
                wr_en_x_g1_7 = 0;

                case (countMemBankOut)
                   0: begin
                    wr_en_w_g1_0 = input_ready;
                    wr_en_w_g1_1 = 0;
                    wr_en_w_g1_2 = 0;
                    wr_en_w_g1_3 = 0;
                    wr_en_w_g1_4 = 0; 
                    wr_en_w_g1_5 = 0; 
                    wr_en_w_g1_6 = 0; 
                    wr_en_w_g1_7 = 0; 
                   end
                   1: begin
                    wr_en_w_g1_0 = 0;
                    wr_en_w_g1_1 = input_ready;
                    wr_en_w_g1_2 = 0;
                    wr_en_w_g1_3 = 0;
                    wr_en_w_g1_4 = 0; 
                    wr_en_w_g1_5 = 0; 
                    wr_en_w_g1_6 = 0; 
                    wr_en_w_g1_7 = 0; 
                   end
                   2: begin
                    wr_en_w_g1_0 = 0;
                    wr_en_w_g1_1 = 0;
                    wr_en_w_g1_2 = input_ready;
                    wr_en_w_g1_3 = 0;
                    wr_en_w_g1_4 = 0; 
                    wr_en_w_g1_5 = 0; 
                    wr_en_w_g1_6 = 0; 
                    wr_en_w_g1_7 = 0; 
                   end
                   3: begin
                    wr_en_w_g1_0 = 0;
                    wr_en_w_g1_1 = 0;
                    wr_en_w_g1_2 = 0;
                    wr_en_w_g1_3 = input_ready;
                    wr_en_w_g1_4 = 0; 
                    wr_en_w_g1_5 = 0; 
                    wr_en_w_g1_6 = 0; 
                    wr_en_w_g1_7 = 0; 
                   end
                   4: begin
                    wr_en_w_g1_0 = 0;
                    wr_en_w_g1_1 = 0;
                    wr_en_w_g1_2 = 0;
                    wr_en_w_g1_3 = 0;
                    wr_en_w_g1_4 = input_ready; 
                    wr_en_w_g1_5 = 0; 
                    wr_en_w_g1_6 = 0; 
                    wr_en_w_g1_7 = 0; 
                   end
                   5: begin
                    wr_en_w_g1_0 = 0;
                    wr_en_w_g1_1 = 0;
                    wr_en_w_g1_2 = 0;
                    wr_en_w_g1_3 = 0;
                    wr_en_w_g1_4 = 0; 
                    wr_en_w_g1_5 = input_ready; 
                    wr_en_w_g1_6 = 0; 
                    wr_en_w_g1_7 = 0; 
                   end
                   6: begin
                    wr_en_w_g1_0 = 0;
                    wr_en_w_g1_1 = 0;
                    wr_en_w_g1_2 = 0;
                    wr_en_w_g1_3 = 0;
                    wr_en_w_g1_4 = 0; 
                    wr_en_w_g1_5 = 0; 
                    wr_en_w_g1_6 = input_ready; 
                    wr_en_w_g1_7 = 0; 
                   end
                   7: begin
                    wr_en_w_g1_0 = 0;
                    wr_en_w_g1_1 = 0;
                    wr_en_w_g1_2 = 0;
                    wr_en_w_g1_3 = 0;
                    wr_en_w_g1_4 = 0; 
                    wr_en_w_g1_5 = 0; 
                    wr_en_w_g1_6 = 0; 
                    wr_en_w_g1_7 = input_ready; 
                   end 
                endcase
                
            end
            else if(countMemState && input_valid) begin
                //enable_cntrReadMem_X = input_ready;
                enable_cntrReadMem_W = 0;
                enable_cntrMemBank = input_ready

                wr_en_w_g1_0 = 0;
                wr_en_w_g1_1 = 0;
                wr_en_w_g1_2 = 0;
                wr_en_w_g1_3 = 0;
                wr_en_w_g1_4 = 0; 
                wr_en_w_g1_5 = 0; 
                wr_en_w_g1_6 = 0; 
                wr_en_w_g1_7 = 0; 


                case (countMemBankOut)
                   0: begin
                    wr_en_x_g1_0 = input_ready; 
                    wr_en_x_g1_1 = 0;
                    wr_en_x_g1_2 = 0;
                    wr_en_x_g1_3 = 0;
                    wr_en_x_g1_4 = 0;
                    wr_en_x_g1_5 = 0;
                    wr_en_x_g1_6 = 0;
                    wr_en_x_g1_7 = 0; 
                   end
                   1: begin
                    wr_en_x_g1_0 = 0; 
                    wr_en_x_g1_1 = input_ready;
                    wr_en_x_g1_2 = 0;
                    wr_en_x_g1_3 = 0;
                    wr_en_x_g1_4 = 0;
                    wr_en_x_g1_5 = 0;
                    wr_en_x_g1_6 = 0;
                    wr_en_x_g1_7 = 0; 
                   end
                   2: begin
                    wr_en_x_g1_0 = 0; 
                    wr_en_x_g1_1 = 0;
                    wr_en_x_g1_2 = input_ready;
                    wr_en_x_g1_3 = 0;
                    wr_en_x_g1_4 = 0;
                    wr_en_x_g1_5 = 0;
                    wr_en_x_g1_6 = 0;
                    wr_en_x_g1_7 = 0;
                   end
                   3: begin
                    wr_en_x_g1_0 = 0; 
                    wr_en_x_g1_1 = 0;
                    wr_en_x_g1_2 = 0;
                    wr_en_x_g1_3 = input_ready;
                    wr_en_x_g1_4 = 0;
                    wr_en_x_g1_5 = 0;
                    wr_en_x_g1_6 = 0;
                    wr_en_x_g1_7 = 0;
                   end
                   4: begin
                    wr_en_x_g1_0 = 0; 
                    wr_en_x_g1_1 = 0;
                    wr_en_x_g1_2 = 0;
                    wr_en_x_g1_3 = 0;
                    wr_en_x_g1_4 = input_ready;
                    wr_en_x_g1_5 = 0;
                    wr_en_x_g1_6 = 0;
                    wr_en_x_g1_7 = 0;
                   end
                   5: begin
                    wr_en_x_g1_0 = 0; 
                    wr_en_x_g1_1 = 0;
                    wr_en_x_g1_2 = 0;
                    wr_en_x_g1_3 = 0;
                    wr_en_x_g1_4 = 0;
                    wr_en_x_g1_5 = input_ready;
                    wr_en_x_g1_6 = 0;
                    wr_en_x_g1_7 = 0;
                   end
                   6: begin
                    wr_en_x_g1_0 = 0; 
                    wr_en_x_g1_1 = 0;
                    wr_en_x_g1_2 = 0;
                    wr_en_x_g1_3 = 0;
                    wr_en_x_g1_4 = 0;
                    wr_en_x_g1_5 = 0;
                    wr_en_x_g1_6 = input_ready;
                    wr_en_x_g1_7 = 0;
                   end
                   7: begin
                    wr_en_x_g1_0 = 0; 
                    wr_en_x_g1_1 = 0;
                    wr_en_x_g1_2 = 0;
                    wr_en_x_g1_3 = 0;
                    wr_en_x_g1_4 = 0;
                    wr_en_x_g1_5 = 0;
                    wr_en_x_g1_6 = 0;
                    wr_en_x_g1_7 = input_ready;
                   end 
                endcase
                
                
            end
        end
            
    end

    //Counter #(4) cntrMem (clk, reset, clear_cntrMem, enable_cntrWriteMem, countMemOut);
    Counter #(WIDTH_MEM_BANK_CNTR) cntrMemBank(clk, reset, clear_cntrMemBank, enable_cntrMemBank, countMemBankOut);
    Counter #(WIDTH_MAC) cntrMac (clk, reset, clear_cntrMac, enable_cntrMac, countMacOut);
    //Counter #(WIDTH_MEM_READ_X) cntrMemX (clk, reset, clear_cntrMemX, enable_cntrReadMem_X, countMem_X_Out);
    Counter #(WIDTH_MEM_READ_W) cntrWriteMemW (clk, reset, clear_cntrWriteMemW, enable_cntrWriteMem_W, countWriteMem_W_Out);
   // Counter #(WIDTH_MEM_READ_W) cntrReadMemW (clk, reset, clear_cntrReadMemW, enable_cntrReadMem_W, cntrReadMem_W_Out);

endmodule



module matvec8_part4(clk, reset, input_valid, input_ready, input_data, new_matrix, output_valid, output_ready, output_data);
    parameter SIZE_X = 2;   //changed
    parameter SIZE_W = 8;  //changed
    parameter SIZE_OUTPUT_MEM = 64;
    parameter WIDTH = 14;
    parameter pipelineStages = 7;
    parameter matrixSize = 8;       //Number of columns
    parameter d0 = 9;       //Base delay(including the pipeline register) when multiplier pipeline stages is 0. changed

    parameter WIDTH_MEM_READ_X = $clog2(SIZE_X);         //Size of counter that writes to memory and reads from memory X (cntrMemX).
    parameter WIDTH_MEM_READ_W = $clog2(SIZE_W);           //Size of counter that writes to memory and reads from memory W (cntrWriteMemW).
    parameter WIDTH_MAC = 7;
    parameter WIDTH_MEM_BANK_CNTR = $clog2(SIZE_W);
    parameter WIDTH_OUTPUT_MEM = $clog2(SIZE_OUTPUT_MEM);

    localparam delay_pipeline_n = d0 + pipelineStages - 1;
    localparam enable_pipeline_reg_after_initial_delay = pipelineStages - 1;
    localparam enable_acc_after_initial_delay = enable_pipeline_reg_after_initial_delay + 1;

    localparam ADDR_X_SIZE = $clog2(SIZE_X);
    localparam ADDR_W_SIZE = $clog2(SIZE_W);

    input clk, reset, input_valid, new_matrix, output_ready;
    input signed [13:0] input_data;

    logic signed [13:0] vectorMemG1_0_data_out, vectorMemG1_1_data_out, vectorMemG1_2_data_out, vectorMemG1_3_data_out, vectorMemG1_4_data_out, vectorMemG1_5_data_out, vectorMemG1_6_data_out, vectorMemG1_7_data_out;
    logic signed [13:0] vectorMemG2_0_data_out, vectorMemG2_1_data_out, vectorMemG2_2_data_out, vectorMemG2_3_data_out, vectorMemG2_4_data_out, vectorMemG2_5_data_out, vectorMemG2_6_data_out, vectorMemG2_7_data_out;
    
    logic signed [13:0] matrixMemG1_0_data_out, matrixMemG1_1_data_out, matrixMemG1_2_data_out, matrixMemG1_3_data_out, matrixMemG1_4_data_out, matrixMemG1_5_data_out, matrixMemG1_6_data_out, matrixMemG1_7_data_out, 
    logic signed [13:0] matrixMemG2_0_data_out, matrixMemG2_1_data_out, matrixMemG2_2_data_out, matrixMemG2_3_data_out, matrixMemG2_4_data_out, matrixMemG2_5_data_out, matrixMemG2_6_data_out, matrixMemG2_7_data_out, 
    logic [ADDR_X_SIZE-1:0] addr_x;
    logic [ADDR_W_SIZE-1:0] addr_w;
    logic wr_en_x_g1_0, wr_en_x_g1_1, wr_en_x_g1_2, wr_en_x_g1_3, wr_en_x_g1_4, wr_en_x_g1_5, wr_en_x_g1_6, wr_en_x_g1_7;
    logic wr_en_x_g2_0, wr_en_x_g2_1, wr_en_x_g2_2, wr_en_x_g2_3, wr_en_x_g2_4, wr_en_x_g2_5, wr_en_x_g2_6, wr_en_x_g2_7;
    
    logic wr_en_w_g1_0, wr_en_w_g1_1, wr_en_w_g1_2, wr_en_w_g1_3, wr_en_w_g1_4, wr_en_w_g1_5, wr_en_w_g1_6, wr_en_w_g1_7;
    logic wr_en_w_g2_0, wr_en_w_g2_1, wr_en_w_g2_2, wr_en_w_g2_3, wr_en_w_g2_4, wr_en_w_g2_5, wr_en_w_g2_6, wr_en_w_g2_7;

    logic clear_acc, en_acc, clear_pipeline_multiplier, clear_reg, en_pipeline_reg, enable_mult;

    logic [27:0] mac_out_0, mac_out_1, mac_out_2, mac_out_3, mac_out_4, mac_out_5, mac_out_7;
    logic signed [27:0] mac_out_final;

    logic [WIDTH_OUTPUT_MEM-1:0] rd_addr, wr_addr;
    logic wr_en_buff, rd_en_buff;

    output logic signed [27:0] output_data;
    output logic output_valid, input_ready;

    logic vecMemWriteGroup, matMemWriteGroup;
    logic vecMemExecGroup, matMemExecGroup;
    logic stall;

    Controller #(ADDR_X_SIZE, ADDR_W_SIZE, WIDTH_MEM_READ_X, WIDTH_MEM_READ_W, WIDTH_MAC, WIDTH_MEM_BANK_CNTR, matrixSize, delay_pipeline_n, pipelineStages, enable_pipeline_reg_after_initial_delay, enable_acc_after_initial_delay) controller(clk, reset, input_valid, new_matrix, output_ready, addr_x, 
    wr_en_x_g1_0, wr_en_x_g1_1, wr_en_x_g1_2, wr_en_x_g1_3, wr_en_x_g1_4, wr_en_x_g1_5, wr_en_x_g1_6, wr_en_x_g1_7,
    // wr_en_x_g2_0, wr_en_x_g2_1, wr_en_x_g2_2, wr_en_x_g2_3, wr_en_x_g2_4, wr_en_x_g2_5, wr_en_x_g2_6, wr_en_x_g2_7, 
    addr_w, 
    wr_en_w_g1_0, wr_en_w_g1_1, wr_en_w_g1_2, wr_en_w_g1_3, wr_en_w_g1_4, wr_en_w_g1_5, wr_en_w_g1_6, wr_en_w_g1_7, 
    // wr_en_w_g2_0, wr_en_w_g2_1, wr_en_w_g2_2, wr_en_w_g2_3, wr_en_w_g2_4, wr_en_w_g2_5, wr_en_w_g2_6, wr_en_w_g2_7, 
    clear_pipeline_multiplier, clear_acc, clear_reg, en_acc, en_pipeline_reg, enable_mult, input_ready, output_valid, count, output_data);

    //Memory Group 1
    memory #(WIDTH, SIZE_X) vectorMemG1_0(clk, input_data, vectorMemG1_0_data_out, 1'b0, wr_en_x_g1_0 );
    memory #(WIDTH, SIZE_X) vectorMemG1_1(clk, input_data, vectorMemG1_1_data_out, 1'b0, wr_en_x_g1_1 );
    memory #(WIDTH, SIZE_X) vectorMemG1_2(clk, input_data, vectorMemG1_2_data_out, 1'b0, wr_en_x_g1_2 );
    memory #(WIDTH, SIZE_X) vectorMemG1_3(clk, input_data, vectorMemG1_3_data_out, 1'b0, wr_en_x_g1_3 );
    memory #(WIDTH, SIZE_X) vectorMemG1_4(clk, input_data, vectorMemG1_4_data_out, 1'b0, wr_en_x_g1_4 );
    memory #(WIDTH, SIZE_X) vectorMemG1_5(clk, input_data, vectorMemG1_5_data_out, 1'b0, wr_en_x_g1_5 );
    memory #(WIDTH, SIZE_X) vectorMemG1_6(clk, input_data, vectorMemG1_6_data_out, 1'b0, wr_en_x_g1_6 );
    memory #(WIDTH, SIZE_X) vectorMemG1_7(clk, input_data, vectorMemG1_7_data_out, 1'b0, wr_en_x_g1_7 );

    memory #(WIDTH, SIZE_W) matrixMemG1_0(clk, input_data, matrixMemG1_0_data_out, addr_w, wr_en_w_g1_0);
    memory #(WIDTH, SIZE_W) matrixMemG1_1(clk, input_data, matrixMemG1_1_data_out, addr_w, wr_en_w_g1_1);
    memory #(WIDTH, SIZE_W) matrixMemG1_2(clk, input_data, matrixMemG1_2_data_out, addr_w, wr_en_w_g1_2);
    memory #(WIDTH, SIZE_W) matrixMemG1_3(clk, input_data, matrixMemG1_3_data_out, addr_w, wr_en_w_g1_3);
    memory #(WIDTH, SIZE_W) matrixMemG1_4(clk, input_data, matrixMemG1_4_data_out, addr_w, wr_en_w_g1_4);
    memory #(WIDTH, SIZE_W) matrixMemG1_5(clk, input_data, matrixMemG1_5_data_out, addr_w, wr_en_w_g1_5);
    memory #(WIDTH, SIZE_W) matrixMemG1_6(clk, input_data, matrixMemG1_6_data_out, addr_w, wr_en_w_g1_6);
    memory #(WIDTH, SIZE_W) matrixMemG1_7(clk, input_data, matrixMemG1_7_data_out, addr_w, wr_en_w_g1_7);



    //Memory Group 2
    // memory #(WIDTH, SIZE_X) vectorMemG2_0(clk, input_data, vectorMemG2_0_data_out, 1'b0, wr_en_x_g2_0);
    // memory #(WIDTH, SIZE_X) vectorMemG2_1(clk, input_data, vectorMemG2_1_data_out, 1'b0, wr_en_x_g2_1);
    // memory #(WIDTH, SIZE_X) vectorMemG2_2(clk, input_data, vectorMemG2_2_data_out, 1'b0, wr_en_x_g2_2);
    // memory #(WIDTH, SIZE_X) vectorMemG2_3(clk, input_data, vectorMemG2_3_data_out, 1'b0, wr_en_x_g2_3);
    // memory #(WIDTH, SIZE_X) vectorMemG2_4(clk, input_data, vectorMemG2_4_data_out, 1'b0, wr_en_x_g2_4);
    // memory #(WIDTH, SIZE_X) vectorMemG2_5(clk, input_data, vectorMemG2_5_data_out, 1'b0, wr_en_x_g2_5);
    // memory #(WIDTH, SIZE_X) vectorMemG2_6(clk, input_data, vectorMemG2_6_data_out, 1'b0, wr_en_x_g2_6);
    // memory #(WIDTH, SIZE_X) vectorMemG2_7(clk, input_data, vectorMemG2_7_data_out, 1'b0, wr_en_x_g2_7);

    // memory #(WIDTH, SIZE_W) matrixMemG2_0(clk, input_data, matrixMemG2_0_data_out, addr_w, wr_en_w_g2_0);
    // memory #(WIDTH, SIZE_W) matrixMemG2_1(clk, input_data, matrixMemG2_1_data_out, addr_w, wr_en_w_g2_1);
    // memory #(WIDTH, SIZE_W) matrixMemG2_2(clk, input_data, matrixMemG2_2_data_out, addr_w, wr_en_w_g2_2);
    // memory #(WIDTH, SIZE_W) matrixMemG2_3(clk, input_data, matrixMemG2_3_data_out, addr_w, wr_en_w_g2_3);
    // memory #(WIDTH, SIZE_W) matrixMemG2_4(clk, input_data, matrixMemG2_4_data_out, addr_w, wr_en_w_g2_4);
    // memory #(WIDTH, SIZE_W) matrixMemG2_5(clk, input_data, matrixMemG2_5_data_out, addr_w, wr_en_w_g2_5);
    // memory #(WIDTH, SIZE_W) matrixMemG2_6(clk, input_data, matrixMemG2_6_data_out, addr_w, wr_en_w_g2_6);
    // memory #(WIDTH, SIZE_W) matrixMemG2_7(clk, input_data, matrixMemG2_7_data_out, addr_w, wr_en_w_g2_7);

    mac_part4 #(pipelineStages, WIDTH) macUnit_0(clk, reset, en_acc, en_pipeline_reg, enable_mult, clear_acc, clear_reg, clear_pipeline_multiplier, vectorMemG1_0_data_out, matrixMemG1_0_data_out, mac_out_0, count);
    mac_part4 #(pipelineStages, WIDTH) macUnit_1(clk, reset, en_acc, en_pipeline_reg, enable_mult, clear_acc, clear_reg, clear_pipeline_multiplier, vectorMemG1_1_data_out, matrixMemG1_1_data_out, mac_out_1, count);
    mac_part4 #(pipelineStages, WIDTH) macUnit_2(clk, reset, en_acc, en_pipeline_reg, enable_mult, clear_acc, clear_reg, clear_pipeline_multiplier, vectorMemG1_2_data_out, matrixMemG1_2_data_out, mac_out_3, count);
    mac_part4 #(pipelineStages, WIDTH) macUnit_3(clk, reset, en_acc, en_pipeline_reg, enable_mult, clear_acc, clear_reg, clear_pipeline_multiplier, vectorMemG1_3_data_out, matrixMemG1_3_data_out, mac_out_4, count);
    mac_part4 #(pipelineStages, WIDTH) macUnit_4(clk, reset, en_acc, en_pipeline_reg, enable_mult, clear_acc, clear_reg, clear_pipeline_multiplier, vectorMemG1_4_data_out, matrixMemG1_4_data_out, mac_out_5, count);
    mac_part4 #(pipelineStages, WIDTH) macUnit_5(clk, reset, en_acc, en_pipeline_reg, enable_mult, clear_acc, clear_reg, clear_pipeline_multiplier, vectorMemG1_5_data_out, matrixMemG1_5_data_out, mac_out_6, count);
    mac_part4 #(pipelineStages, WIDTH) macUnit_6(clk, reset, en_acc, en_pipeline_reg, enable_mult, clear_acc, clear_reg, clear_pipeline_multiplier, vectorMemG1_6_data_out, matrixMemG1_6_data_out, mac_out_7, count);
    mac_part4 #(pipelineStages, WIDTH) macUnit_7(clk, reset, en_acc, en_pipeline_reg, enable_mult, clear_acc, clear_reg, clear_pipeline_multiplier, vectorMemG1_7_data_out, matrixMemG1_7_data_out, mac_out_8, count);
    
    pipelined_adders pipelined_adders(clk, reset, en_adders, clear_adders, macUnit_0, mac_out_1, mac_out_2, mac_out_3, mac_out_4, mac_out_5, mac_out_6, mac_out_7, mac_out_final);

    output_memory #(WIDTH, SIZE_OUTPUT_MEM) output_buffer(clk, mac_out_final, output_data, wr_addr, rd_addr, wr_en_buff, rd_en_buff);

endmodule