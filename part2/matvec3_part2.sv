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

module Controller(clk, reset, input_valid, new_matrix, output_ready, addr_x, wr_en_x, addr_w, wr_en_w, clear_acc, clear_reg, en_acc, en_pipeline_reg, enable_mult, input_ready, output_valid, count, output_data);

    parameter ADDR_X_SIZE = 2;
    parameter ADDR_W_SIZE = 4;
    parameter WIDTH_MEM_READ_X = 2;         //Size of counter that writes to memory and reads from memory X (cntrMemX)
    parameter WIDTH_MEM_READ_W = 4;         //Size of counter that writes to memory and reads from memory W (cntrMemW)
    parameter WIDTH_MAC = 4;                //Size of counter that handles MAC delay(cntrMac)

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
    output logic wr_en_x, wr_en_w, clear_acc, clear_reg, en_acc, en_pipeline_reg, enable_mult;    

    logic countMemState;        //State that keeps track of weather the counter is outputting addresses for the matrix memory or the vector memory.     
    logic operationState;   //0 -> writing state, 1 -> reading state

    logic clear_cntrMem, enable_cntrWriteMem;        //Counter that handles (produces addresses) to write to both memories
    logic clear_cntrMac, enable_cntrMac;             //Counter that handles delay in MAC arithmetic for output_valid signals just for initial stages until the pipeline if full
    logic clear_cntrMemX, enable_cntrReadMem_X;      //Counter that handles (produces addresses) to read from vector memory (X)
    logic clear_cntrMemW, enable_cntrReadMem_W;      //Counter that handles (produces addresses) to read from matrix memory (W)

    logic [WIDTH_MEM_READ_W-1:0] countMemOut, countMemOutDelay;
    logic [WIDTH_MAC-1:0] countMacOut;
    logic [WIDTH_MEM_READ_X-1:0] countMem_X_Out;
    logic [WIDTH_MEM_READ_W-1:0] countMem_W_Out;


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

        if((countMacOut == (delay_pipeline_n) || countMacOut == (delay_pipeline_n + matrixSize) || countMacOut == (delay_pipeline_n + 2 * matrixSize)) && ~clear_acc) begin
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
        

        if(clear_acc && countMacOut != (delay_pipeline_n + 2 * matrixSize)) begin
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
            // addr_w <= countMem_W_Out;
            // addr_x <= countMem_X_Out;
            if(new_matrix || ~new_matrix)
                input_ready <= 1;
            //clear_cntrMem <= 0;
            //clear_cntrMemX <= 0;
            clear_cntrMemW <= 0;

            if(input_valid) begin
                if(~countMemState && countMem_W_Out == 8) begin
                    //input_ready <= 0;
                    //clear_cntrMem <= 1;
                    countMemState <= 1;
                end
                else if(countMemState && countMem_X_Out == 2) begin
                    input_ready <= 0;
                    //clearcntmem <= 0;
                    countMemState <= 0;
                    operationState <= 1;
                    //clear_cntrMemX <= 1;
                    clear_cntrMemW <= 1;
                    clear_cntrMac <= 1;
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
            // addr_w = countMem_W_Out;
            //clear_cntrMemX <= (countMem_X_Out == 1) ? 1 : 0;
            clear_cntrMemW <= 0;
            clear_cntrMac <= 0;

            if(countMacOut == (delay_pipeline_n + 2 * matrixSize) && clear_acc) begin
                clear_cntrMac <= 1;
                clear_cntrMemW <= 1;
                operationState <= 0;
            end
        end
        
    end


    always_comb begin
        //enable_cntrWriteMem = input_ready;
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

            if((countMacOut == (delay_pipeline_n) || countMacOut == (delay_pipeline_n + matrixSize) || countMacOut == (delay_pipeline_n + 2 * matrixSize)) && ~clear_acc) begin
                enable_cntrReadMem_X = 0;
                enable_cntrReadMem_W = 0;
                enable_cntrMac = 0;

            end

            clear_cntrMemX = (countMem_X_Out == 2) && (enable_cntrReadMem_X) ? 1 : 0;

            // if(countMacOut == 11) begin
            //     clear_cntrMemX = 1;
            // end
            // else begin
            //     clear_cntrMemX = 0;
            // end
            
        end
        else begin              //write mode
            
            enable_cntrMac = 0;
            //wr_en_w = 0;
            // if(countMem_X_Out == 3)
            //     clear_cntrMemX = 1;
            // else
            //     clear_cntrMemX = 0;
            
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

    //Counter #(4) cntrMem (clk, reset, clear_cntrMem, enable_cntrWriteMem, countMemOut);
    Counter #(WIDTH_MAC) cntrMac (clk, reset, clear_cntrMac, enable_cntrMac, countMacOut);
    Counter #(WIDTH_MEM_READ_X) cntrMemX (clk, reset, clear_cntrMemX, enable_cntrReadMem_X, countMem_X_Out);
    Counter #(WIDTH_MEM_READ_W) cntrMemW (clk, reset, clear_cntrMemW, enable_cntrReadMem_W, countMem_W_Out);

endmodule



module matvec3_part2(clk, reset, input_valid, input_ready, input_data, new_matrix, output_valid, output_ready, output_data);
    parameter SIZE_X = 3;
    parameter SIZE_W = 9;
    parameter WIDTH = 14;
    parameter pipelineStages = 7;
    parameter matrixSize = 3;
    parameter d0 = 4;       //Base delay(including the pipeline register) when multiplier pipeline stages is 0.

    parameter WIDTH_MEM_READ_X = 2;         //Size of counter that writes to memory and reads from memory X (cntrMemX).
    parameter WIDTH_MEM_READ_W = 4;           //Size of counter that writes to memory and reads from memory W (cntrMemW).
    parameter WIDTH_MAC = 5;

    localparam delay_pipeline_n = d0 + pipelineStages - 1;
    localparam enable_pipeline_reg_after_initial_delay = pipelineStages - 1;
    localparam enable_acc_after_initial_delay = enable_pipeline_reg_after_initial_delay + 1;

    localparam ADDR_X_SIZE = $clog2(SIZE_X);
    localparam ADDR_W_SIZE = $clog2(SIZE_W);

    input clk, reset, input_valid, new_matrix, output_ready;
    input signed [13:0] input_data;

    logic signed [13:0] vectorMem_data_out, matrixMem_data_out;
    logic [ADDR_X_SIZE-1:0] addr_x;
    logic [ADDR_W_SIZE-1:0] addr_w;
    logic wr_en_x, wr_en_w;
    logic clear_acc, en_acc, clear_reg, en_pipeline_reg, enable_mult;


    output logic signed [27:0] output_data;
    output logic output_valid, input_ready;
    logic [1:0] count;

    Controller #(ADDR_X_SIZE, ADDR_W_SIZE, WIDTH_MEM_READ_X, WIDTH_MEM_READ_W, WIDTH_MAC, matrixSize, delay_pipeline_n, pipelineStages, enable_pipeline_reg_after_initial_delay, enable_acc_after_initial_delay) controller(clk, reset, input_valid, new_matrix, output_ready, addr_x, wr_en_x, addr_w, wr_en_w, clear_acc, clear_reg, en_acc, en_pipeline_reg, enable_mult, input_ready, output_valid, count, output_data);

    memory #(WIDTH, SIZE_X) vectorMem(clk, input_data, vectorMem_data_out, addr_x, wr_en_x );
    memory  #(WIDTH, SIZE_W) matrixMem(clk, input_data, matrixMem_data_out, addr_w, wr_en_w);

    mac_part2 #(pipelineStages, WIDTH) macUnit(clk, reset, en_acc, en_pipeline_reg, enable_mult, clear_acc, clear_reg, vectorMem_data_out, matrixMem_data_out, output_data, count);

endmodule