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

module Controller(clk, reset, input_valid, output_ready, addr_x, wr_en_x, addr_w, wr_en_w, clear_acc, clear_reg, en_acc, en_pipeline_reg, input_ready, output_valid, count, output_data);

    parameter ADDR_X_SIZE = 2;
    parameter ADDE_W_SIZE = 4;
    parameter WIDTH_MEM_WR_W = 4;           //Size of counter that writes to memory and reads from memory W (cntrMem & cntrMemW)
    parameter WIDTH_MAC_X = 4;              //Size of counter that handles MAC delay and reads from memory X (cntrMac & cntrMemX)
    parameter WIDTH_MEM_READ_X = 2;
    parameter mac_delay = 3;

    input clk, reset, input_valid, output_ready;
    input [1:0] count;
    output logic input_ready, output_valid;
    input logic signed [27:0] output_data;

    output logic [ADDR_X_SIZE-1:0] addr_x;  
    output logic [ADDE_W_SIZE-1:0] addr_w;
    output logic wr_en_x, wr_en_w, clear_acc, clear_reg, en_acc, en_pipeline_reg;    

    logic countMemState;        //State that keeps track of weather the counter is outputting addresses for the matrix memory or the vector memory.     
    logic operationState;   //0 -> writing state, 1 -> reading state

    logic clear_cntrMem, enable_cntrWriteMem;        //Counter that handles (produces addresses) to write to both memories
    logic clear_cntrMac, enable_cntrMac;             //Counter that handles delay in MAC arithmetic for output_valid signals just for initial stages until the pipeline if full
    logic clear_cntrMemX, enable_cntrReadMem_X;      //Counter that handles (produces addresses) to read from vector memory (X)
    logic clear_cntrMemW, enable_cntrReadMem_W;      //Counter that handles (produces addresses) to read from matrix memory (W)

    logic [WIDTH_MEM_WR_W-1:0] countMemOut, countMemOutDelay;
    logic [WIDTH_MAC_X-1:0] countMacOut;
    logic [WIDTH_MEM_READ_X-1:0] countMem_X_Out;
    logic [WIDTH_MEM_WR_W-1:0] countMem_W_Out;


    always_ff @( posedge clk ) begin
        if(reset) begin
            output_valid <= 0;
            en_acc <= 0;
            en_pipeline_reg <= 0;

            //new
            countMemState <= 0;
            operationState <= 0;
            //new
            
        end

        if((countMacOut == 4 || countMacOut == 7 || countMacOut == 10) && ~clear_acc) begin
            output_valid <= 1;
            en_acc <= 0;
            en_pipeline_reg <= 0;
        end
        
        if(countMacOut == 0) begin
            en_pipeline_reg <= 1;
        end

        if(countMacOut == 1) begin
            en_acc <= 1;
        end       
        

        if(clear_acc && countMacOut != 10) begin
            en_acc <= 1;
            en_pipeline_reg <= 1;

        end

        if(~operationState) begin
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
                end
            end
        end
        else if(operationState) begin
            // addr_x = countMem_X_Out;
            // addr_w = countMem_W_Out;
            //clear_cntrMemX <= (countMem_X_Out == 1) ? 1 : 0;
            clear_cntrMemW <= 0;
            clear_cntrMac <= 0;

            if(countMacOut == 10 && clear_acc) begin
                clear_cntrMac <= 1;
                clear_cntrMemW <= 1;
                operationState <= 0;
            end





        end
        
    end

    // always_ff @( posedge clk ) begin
    //     if(~operationState) begin
    //         // addr_w <= countMem_W_Out;
    //         // addr_x <= countMem_X_Out;
    //         input_ready <= 1;
    //         //clear_cntrMem <= 0;
    //         //clear_cntrMemX <= 0;
    //         clear_cntrMemW <= 0;

    //         if(input_valid) begin
    //             if(~countMemState && countMem_W_Out == 8) begin
    //                 //input_ready <= 0;
    //                 //clear_cntrMem <= 1;
    //                 countMemState <= 1;
    //             end
    //             else if(countMemState && countMem_X_Out == 2) begin
    //                 input_ready <= 0;
    //                 //clearcntmem <= 0;
    //                 countMemState <= 0;
    //                 operationState <= 1;
    //                 //clear_cntrMemX <= 1;
    //                 clear_cntrMemW <= 1;
    //                 clear_cntrMac <= 1;
    //             end
    //         end
    //     end
    //     else if(operationState) begin
    //         // addr_x = countMem_X_Out;
    //         // addr_w = countMem_W_Out;
    //         //clear_cntrMemX <= (countMem_X_Out == 1) ? 1 : 0;
    //         clear_cntrMemW <= 0;
    //         clear_cntrMac <= 0;

    //         if(countMacOut == 10 && clear_acc) begin
    //             clear_cntrMac <= 1;
    //             clear_cntrMemW <= 1;
    //             operationState <= 0;
    //         end





    //     end
        
    // end

    // always_comb begin
    //     if(operationState) begin
    //         enable_cntrReadMem_X = ~output_valid;
    //         enable_cntrReadMem_W = ~output_valid;
    //         enable_cntrMac = ~output_valid;
    //     end
        
    // end

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

            if((countMacOut == 4 || countMacOut == 7 || countMacOut == 10) && ~clear_acc) begin
                enable_cntrReadMem_X = 0;
                enable_cntrReadMem_W = 0;
                enable_cntrMac = 0;

            end

            clear_cntrMemX = (countMem_X_Out == 2) ? 1 : 0;

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
            
            clear_cntrMemX = (countMem_X_Out == 3) || (countMacOut == 11) ? 1 : 0;



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



    // always_comb begin
        
    //     //TODO add enable_pipeline_multipliesr = ~stall
    //     if(reset) begin
    //         countMemState = 0;
    //         operationState = 0;
    //     end
    //     if(~operationState) begin   //write mode
    //         addr_w = countMemOut;
    //         addr_x = countMemOut;
    //         input_ready = 1;
            
    //         if(input_valid) begin
    //             //input_ready = 1;
    //             enable_cntrWriteMem = 1;
    //             //clear_cntrMem = 0;
    //             if(~countMemState) begin
    //                 // wr_en_w = input_ready; //enable write W
    //                 // wr_en_x = 0
    //                 // countMemState = 0;
    //                 if(countMemOut == 9) begin
    //                     input_ready = 0;
    //                     wr_en_w = 0;     //disable write W
    //                     wr_en_x = 0;
    //                     clear_cntrMem = 1;     //enable clear signal
    //                     countMemState = 1;                              
    //                 end
    //                 else begin
    //                     input_ready = 1;
    //                     wr_en_w = input_ready;     //enable write W
    //                     wr_en_x = 0;
    //                     clear_cntrMem = 0;     //disble clear signal
    //                     countMemState = 0; 
    //                 end

    //             end
    //             else if(countMemState) begin
    //                 input_ready = 1;
    //                 wr_en_x = input_ready;  //enable write X 
    //                 wr_en_w = 0;
    //                 countMemState = 1;
    //                 if(countMemOut == 3) begin
    //                     wr_en_x = 0;     //disable write X
    //                     clear_cntrMem = 1;        //enable clear signal
    //                     countMemState = 0;
    //                     input_ready = 0; //not ready since we are gonna read
    //                     initial_enable = 1;
    //                     operationState = 1;
    //                 end
    //                 else begin
    //                     wr_en_x = input_ready;     //disable write X
    //                     clear_cntrMem = 1;        //enable clear signal
    //                     countMemState = 0;
    //                     input_ready = 0; //not ready since we are gonna read
    //                     initial_enable = 1;
    //                     operationState = 1;
    //                 end
                    
    //             end
    //         end

    //         else begin
    //             enable_cntrWriteMem = 0; //disable write address counter
    //         end
    //     end

    //     else if(operationState) begin
    //         addr_x = countMem_X_Out;
    //         addr_w = countMem_W_Out;

    //         enable_cntrMac = 1;
    //         enable_cntrReadMem_X = 1;
    //         enable_cntrReadMem_W = 1;

    //         clear_cntrMemX = 0;
    //         clear_cntrMemW = 0;
    //         clear_cntrMac = 0;
            
    //         if((countMacOut == 4 || countMacOut == 7 || countMacOut == 10)) begin
    //             enable_cntrMac = 0;
    //             enable_cntrReadMem_X = 0;
    //             enable_cntrReadMem_W = 0;
    //         end
    //         else if(clear_acc) begin
    //             enable_cntrMac = 1;
    //             enable_cntrReadMem_X = 1;
    //             enable_cntrReadMem_W = 1;
    //         end

    //         else if(countMacOut == 11) begin
    //             operationState = 0;
    //             enable_cntrMac = 0;
    //             enable_cntrReadMem_X = 0;
    //             enable_cntrReadMem_W = 0;
    //             clear_cntrMac = 1;
    //             clear_cntrMemX = 1;
    //             clear_cntrMemW = 1;
    //         end

    //         if(countMem_X_Out == 2) begin
    //             clear_cntrMemX = 1;
    //         end

    //         if(output_valid) begin
    //             enable_cntrMac = 0;
    //             enable_cntrReadMem_X = 0;
    //             enable_cntrReadMem_W = 0;
    //         end
           
    //     end

    // end
    Counter #(4) cntrMem (clk, reset, clear_cntrMem, enable_cntrWriteMem, countMemOut);
    Counter #(WIDTH_MAC_X) cntrMac (clk, reset, clear_cntrMac, enable_cntrMac, countMacOut);
    Counter #(WIDTH_MEM_READ_X) cntrMemX (clk, reset, clear_cntrMemX, enable_cntrReadMem_X, countMem_X_Out);
    Counter #(4) cntrMemW (clk, reset, clear_cntrMemW, enable_cntrReadMem_W, countMem_W_Out);

endmodule



module matvec3_part1(clk, reset, input_valid, input_ready, input_data, output_valid, output_ready, output_data);
    parameter SIZE_X = 4;
    parameter SIZE_W = 16;

    localparam LOGSIZE_X = $clog2(SIZE_X);
    localparam LOGSIZE_W = $clog2(SIZE_W);

    input clk, reset, input_valid, output_ready;
    input signed [13:0] input_data;

    logic signed [13:0] vectorMem_data_out, matrixMem_data_out;
    logic [LOGSIZE_X-1:0] addr_x;
    logic [LOGSIZE_W-1:0] addr_w;
    logic wr_en_x, wr_en_w;
    logic clear_acc, en_acc, clear_reg, en_pipeline_reg;
    logic en_multiplier;


    output logic signed [27:0] output_data;
    output logic output_valid, input_ready;
    logic [1:0] count;

    Controller #(2, 4) controller(clk, reset, input_valid, output_ready, addr_x, wr_en_x, addr_w, wr_en_w, clear_acc, clear_reg, en_acc, en_pipeline_reg, input_ready, output_valid, count, output_data);

    memory #(14, 3) vectorMem(clk, input_data, vectorMem_data_out, addr_x, wr_en_x );
    memory  #(14, 9) matrixMem(clk, input_data, matrixMem_data_out, addr_w, wr_en_w);

    part4b_mac macUnit(clk, reset, en_acc, en_pipeline_reg, clear_acc, clear_reg, vectorMem_data_out, matrixMem_data_out, output_data, count);

endmodule