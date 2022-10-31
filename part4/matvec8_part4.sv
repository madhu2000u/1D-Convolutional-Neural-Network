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

module Controller(clk, reset, input_valid, new_matrix, output_ready, addr_x, 
    wr_en_x_g1_0, wr_en_x_g1_1, wr_en_x_g1_2, wr_en_x_g1_3, wr_en_x_g1_4, wr_en_x_g1_5, wr_en_x_g1_6, wr_en_x_g1_7, addr_w, 
    wr_en_w_g1_0, wr_en_w_g1_1, wr_en_w_g1_2, wr_en_w_g1_3, wr_en_w_g1_4, wr_en_w_g1_5, wr_en_w_g1_6, wr_en_w_g1_7, wr_en_buff, rd_addr, wr_addr,
    clear_pipeline_multiplier, enable_mult, input_ready, output_valid, output_data);

    parameter ADDR_X_SIZE = 2;
    parameter ADDR_W_SIZE = 4;
    parameter WIDTH_MEM_READ_X = 2;                             //Size of counter that writes to memory and reads from memory X (cntrMemX)
    parameter WIDTH_MEM_READ_W = 4;                             //Size of counter that writes to memory and reads from memory W (cntrWriteMemW)
    parameter WIDTH_MAC = 4;                                    //Size of counter that handles MAC delay(cntrMac)
    parameter WIDTH_MEM_BANK_CNTR = 8;
    parameter WIDTH_OUTPUT_MEM = 5;

    parameter matrixSize = 3;
    parameter delay_pipeline_n = 4;
    parameter pipelineStages = 0;

    input clk, reset, input_valid, new_matrix, output_ready;
    output logic input_ready, output_valid;
    input logic signed [27:0] output_data;

    output logic wr_en_buff;
    output logic [ADDR_X_SIZE-1:0] addr_x;  
    output logic [ADDR_W_SIZE-1:0] addr_w;
    output logic [WIDTH_OUTPUT_MEM-1:0] rd_addr, wr_addr;
    output logic wr_en_x_g1_0, wr_en_x_g1_1, wr_en_x_g1_2, wr_en_x_g1_3, wr_en_x_g1_4, wr_en_x_g1_5, wr_en_x_g1_6, wr_en_x_g1_7;
    output logic wr_en_w_g1_0, wr_en_w_g1_1, wr_en_w_g1_2, wr_en_w_g1_3, wr_en_w_g1_4, wr_en_w_g1_5, wr_en_w_g1_6, wr_en_w_g1_7;
    output logic clear_pipeline_multiplier, enable_mult;    

    logic countMemState;                                        //0 -> state that tells we are writing to matrix, 1 -> state that tells we are writing to vector     
    logic operationState;                                       //0 -> writing state, 1 -> reading/execution state 
    logic valid_out_internal;                                   //Buffer should know when to store the valid values

    logic clear_cntrMem, enable_cntrWriteMem;                   //Counter that handles (produces addresses) to write to both memories
    logic clear_cntrMac, enable_cntrMac;                        //Counter that handles delay in MAC arithmetic for output_valid signals just for initial stages until the pipeline if full
    logic clear_cntrWriteMemW, enable_cntrWriteMem_W;           //Counter that handles (produces addresses) to read from matrix memory (W)
    logic clear_cntrMemBank, enable_cntrMemBank;
    logic clear_cntrOutputBufferWrite, enable_cntrOutputBufferWrite;
    logic clear_cntrOutputBufferRead, enable_cntrOutputBufferRead;
    logic buffer_ready;

    logic [WIDTH_MEM_READ_W-1:0] countMemOut, countMemOutDelay;
    logic [WIDTH_MAC-1:0] countMacOut;
    logic [WIDTH_MEM_READ_X-1:0] countMem_X_Out;
    logic [WIDTH_MEM_READ_W-1:0] countWriteMem_W_Out;
    logic [WIDTH_MEM_BANK_CNTR-1:0] countMemBankOut;
    logic [WIDTH_OUTPUT_MEM-1:0] countOutputBufferWriteOut;
    logic [WIDTH_OUTPUT_MEM-1:0] countOutputBufferReadOut;


    always_ff @( posedge clk ) begin
        if(reset) begin
            output_valid <= 0;
            countMemState <= 0;
            operationState <= 0;
        end


        if((countOutputBufferWriteOut == countOutputBufferReadOut + 6'b1 && output_valid && output_ready) || countOutputBufferWriteOut == countOutputBufferReadOut) begin
            output_valid <= 0;
        end
        else if(countOutputBufferWriteOut > 0) begin
            output_valid <= 1;
        end

        if(~operationState) begin
            if(new_matrix || ~new_matrix)
                input_ready <= 1;
            clear_cntrWriteMemW <= 0;

            if(input_valid) begin
                if(~countMemState && countWriteMem_W_Out == 7 && countMemBankOut == 7) begin
                    countMemState <= 1;
                end
                else if(countMemState && countMemBankOut == 7) begin
                    input_ready <= 0;
                    countMemState <= 0;
                    operationState <= 1;
                    clear_cntrWriteMemW <= 1;
                    clear_cntrMac <= 1;
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
            clear_cntrWriteMemW <= 0;
            clear_cntrMac <= 0;
            clear_pipeline_multiplier <= 0;

            if(countOutputBufferWriteOut == countOutputBufferReadOut - 1) begin
                buffer_ready <= 0;
            end
            else begin
                buffer_ready <= 1;
            end


            if(countMacOut == delay_pipeline_n) begin
                valid_out_internal <= 1;
            end

            if((countMacOut == (delay_pipeline_n + matrixSize))) begin     //matrixSize is the offset of the final output of the matrix-vector product
                valid_out_internal <= 0;
                operationState <= 0;
                clear_cntrWriteMemW <= 1;
            end

        end
        
    end


    always_comb begin
        addr_w = countWriteMem_W_Out;
        rd_addr = countOutputBufferReadOut;
        wr_addr = countOutputBufferWriteOut;
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

        enable_cntrWriteMem_W = 0;
        enable_cntrMac = 0;
        enable_cntrMemBank = 0;
        if(output_ready && output_valid) begin
            enable_cntrOutputBufferRead = 1;
        end
        else begin
            enable_cntrOutputBufferRead = 0;
        end


        if(operationState) begin    //read mode
            enable_cntrWriteMem_W = (countWriteMem_W_Out == (matrixSize) - 1) ? 0 : 1;
            enable_cntrMac = 1;

            if(buffer_ready && valid_out_internal) begin
                wr_en_buff = 1;
                enable_cntrOutputBufferWrite = 1;
            end
            else begin
                wr_en_buff = 0;
                enable_cntrOutputBufferWrite = 0;
            end
        end

        else begin              //write mode
            
            enable_cntrMac = 0;
            wr_en_buff = 0;
            enable_cntrOutputBufferWrite = 0;
            
            if((~countMemState && ~input_valid) || (countMemState && ~input_valid)) begin
                enable_cntrWriteMem_W = input_valid;
                enable_cntrMemBank = input_valid;

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
                enable_cntrMemBank = input_ready;

                if(countMemBankOut == 7)
                    enable_cntrWriteMem_W = input_ready;
                else
                    enable_cntrWriteMem_W = 0;

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
                enable_cntrWriteMem_W = 0;
                enable_cntrMemBank = input_ready;

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

    Counter #(WIDTH_MEM_BANK_CNTR) cntrMemBank(clk, reset, clear_cntrMemBank, enable_cntrMemBank, countMemBankOut);                         //Counter that selects between different memory "banks" to add data for parallelism
    Counter #(WIDTH_MAC) cntrMac (clk, reset, clear_cntrMac, enable_cntrMac, countMacOut);                                                  //Counter that tracks execution delays and outpu_valid delays
    Counter #(WIDTH_MEM_READ_W) cntrWriteMemW (clk, reset, clear_cntrWriteMemW, enable_cntrWriteMem_W, countWriteMem_W_Out);                //Address counter for reading and writing to matrix memories
    Counter #(6) cntrOutputBufferWrite(clk, reset, clear_cntrOutputBufferWrite, enable_cntrOutputBufferWrite, countOutputBufferWriteOut);   //Address counter that writes to the output buffer
    Counter #(6) cntrOutputBufferRead(clk, reset, clear_cntrOutputBufferRead, enable_cntrOutputBufferRead, countOutputBufferReadOut);       //Address counter that reads and gives the output from the output buffer.

endmodule



module matvec8_part4(clk, reset, input_valid, input_ready, input_data, new_matrix, output_valid, output_ready, output_data);
    parameter SIZE_X = 2;   
    parameter SIZE_W = 8;  
    parameter SIZE_OUTPUT_MEM = 64;
    parameter WIDTH = 14;
    parameter WIDTH_OUTPUT_BUFFER = 28;
    parameter pipelineStages = 5;
    parameter matrixSize = 8;                                   //Number of columns
    parameter d0 = 3;                                           //Base delay(including the pipeline register) when multiplier pipeline stages is 0. changed

    parameter WIDTH_MEM_READ_X = $clog2(SIZE_X);                //Width of counter that writes to memory and reads from memory X (cntrMemX).
    parameter WIDTH_MEM_READ_W = $clog2(SIZE_W);                //Width of counter that writes to memory and reads from memory W (cntrMemW).
    parameter WIDTH_MAC = 7;                                    //Width of counter that calculates execution delay
    parameter WIDTH_MEM_BANK_CNTR = $clog2(SIZE_W);
    parameter WIDTH_OUTPUT_MEM = $clog2(SIZE_OUTPUT_MEM);

    localparam delay_pipeline_n = d0 + pipelineStages;

    localparam ADDR_X_SIZE = $clog2(SIZE_X);
    localparam ADDR_W_SIZE = $clog2(SIZE_W);

    input clk, reset, input_valid, new_matrix, output_ready;
    input signed [13:0] input_data;

    logic signed [13:0] vectorMemG1_0_data_out, vectorMemG1_1_data_out, vectorMemG1_2_data_out, vectorMemG1_3_data_out, vectorMemG1_4_data_out, vectorMemG1_5_data_out, vectorMemG1_6_data_out, vectorMemG1_7_data_out;
    logic signed [13:0] vectorMemG2_0_data_out, vectorMemG2_1_data_out, vectorMemG2_2_data_out, vectorMemG2_3_data_out, vectorMemG2_4_data_out, vectorMemG2_5_data_out, vectorMemG2_6_data_out, vectorMemG2_7_data_out;
    
    logic signed [13:0] matrixMemG1_0_data_out, matrixMemG1_1_data_out, matrixMemG1_2_data_out, matrixMemG1_3_data_out, matrixMemG1_4_data_out, matrixMemG1_5_data_out, matrixMemG1_6_data_out, matrixMemG1_7_data_out; 
    logic signed [13:0] matrixMemG2_0_data_out, matrixMemG2_1_data_out, matrixMemG2_2_data_out, matrixMemG2_3_data_out, matrixMemG2_4_data_out, matrixMemG2_5_data_out, matrixMemG2_6_data_out, matrixMemG2_7_data_out; 
    logic [ADDR_X_SIZE-1:0] addr_x;
    logic [ADDR_W_SIZE-1:0] addr_w;
    logic wr_en_x_g1_0, wr_en_x_g1_1, wr_en_x_g1_2, wr_en_x_g1_3, wr_en_x_g1_4, wr_en_x_g1_5, wr_en_x_g1_6, wr_en_x_g1_7;
    logic wr_en_x_g2_0, wr_en_x_g2_1, wr_en_x_g2_2, wr_en_x_g2_3, wr_en_x_g2_4, wr_en_x_g2_5, wr_en_x_g2_6, wr_en_x_g2_7;
    
    logic wr_en_w_g1_0, wr_en_w_g1_1, wr_en_w_g1_2, wr_en_w_g1_3, wr_en_w_g1_4, wr_en_w_g1_5, wr_en_w_g1_6, wr_en_w_g1_7;
    logic wr_en_w_g2_0, wr_en_w_g2_1, wr_en_w_g2_2, wr_en_w_g2_3, wr_en_w_g2_4, wr_en_w_g2_5, wr_en_w_g2_6, wr_en_w_g2_7;

    logic clear_pipeline_multiplier, enable_mult;

    logic signed [27:0] mac_out_0, mac_out_1, mac_out_2, mac_out_3, mac_out_4, mac_out_5, mac_out_6, mac_out_7;
    logic signed [27:0] mac_out_final;

    logic [WIDTH_OUTPUT_MEM-1:0] rd_addr, wr_addr;
    logic wr_en_buff;

    output logic signed [27:0] output_data;
    output logic output_valid, input_ready;

    Controller #(ADDR_X_SIZE, ADDR_W_SIZE, WIDTH_MEM_READ_X, WIDTH_MEM_READ_W, WIDTH_MAC, WIDTH_MEM_BANK_CNTR, WIDTH_OUTPUT_MEM, matrixSize, delay_pipeline_n, pipelineStages) controller(clk, reset, input_valid, new_matrix, output_ready, addr_x, 
    wr_en_x_g1_0, wr_en_x_g1_1, wr_en_x_g1_2, wr_en_x_g1_3, wr_en_x_g1_4, wr_en_x_g1_5, wr_en_x_g1_6, wr_en_x_g1_7, addr_w, 
    wr_en_w_g1_0, wr_en_w_g1_1, wr_en_w_g1_2, wr_en_w_g1_3, wr_en_w_g1_4, wr_en_w_g1_5, wr_en_w_g1_6, wr_en_w_g1_7, wr_en_buff, rd_addr, wr_addr,
    clear_pipeline_multiplier, enable_mult, input_ready, output_valid, output_data);

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


    mac_part4 #(pipelineStages, WIDTH) macUnit_0(clk, reset, 1'b1, clear_pipeline_multiplier, vectorMemG1_0_data_out, matrixMemG1_0_data_out, mac_out_0);
    mac_part4 #(pipelineStages, WIDTH) macUnit_1(clk, reset, 1'b1, clear_pipeline_multiplier, vectorMemG1_1_data_out, matrixMemG1_1_data_out, mac_out_1);
    mac_part4 #(pipelineStages, WIDTH) macUnit_2(clk, reset, 1'b1, clear_pipeline_multiplier, vectorMemG1_2_data_out, matrixMemG1_2_data_out, mac_out_2);
    mac_part4 #(pipelineStages, WIDTH) macUnit_3(clk, reset, 1'b1, clear_pipeline_multiplier, vectorMemG1_3_data_out, matrixMemG1_3_data_out, mac_out_3);
    mac_part4 #(pipelineStages, WIDTH) macUnit_4(clk, reset, 1'b1, clear_pipeline_multiplier, vectorMemG1_4_data_out, matrixMemG1_4_data_out, mac_out_4);
    mac_part4 #(pipelineStages, WIDTH) macUnit_5(clk, reset, 1'b1, clear_pipeline_multiplier, vectorMemG1_5_data_out, matrixMemG1_5_data_out, mac_out_5);
    mac_part4 #(pipelineStages, WIDTH) macUnit_6(clk, reset, 1'b1, clear_pipeline_multiplier, vectorMemG1_6_data_out, matrixMemG1_6_data_out, mac_out_6);
    mac_part4 #(pipelineStages, WIDTH) macUnit_7(clk, reset, 1'b1, clear_pipeline_multiplier, vectorMemG1_7_data_out, matrixMemG1_7_data_out, mac_out_7);
    
    pipelined_adders pipelined_adders(clk, reset, mac_out_0, mac_out_1, mac_out_2, mac_out_3, mac_out_4, mac_out_5, mac_out_6, mac_out_7, mac_out_final);

    output_memory #(WIDTH_OUTPUT_BUFFER, SIZE_OUTPUT_MEM) output_buffer(clk, mac_out_final, output_data, wr_addr, rd_addr, wr_en_buff);

endmodule