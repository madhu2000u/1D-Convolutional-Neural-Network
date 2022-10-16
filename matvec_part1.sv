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

module Controller(clk, reset, input_valid, output_ready, addr_x, wr_en_x, addr_w, wr_en_w, clear_acc, clear_reg, en_acc, en_pipeline_reg, input_ready, output_valid, count, output_data);

    parameter ADDR_X_SIZE = 2;
    parameter ADDE_W_SIZE = 4;
    parameter WIDTH_MEM_WR_W = 4;           //Size of counter that writes to memory and reads from memory W (cntrMem & cntrMemW)
    parameter WIDTH_MAC_X = 3;              //Size of counter that handles MAC delay and reads from memory X (cntrMac & cntrMemX)
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
    logic [1:0]countMacState;
    logic operationState;   //0 -> writing state, 1 -> reading state
    logic initial_enable;   //indicates that the read mode has started (useful when we have pipeline since initially we need to fill the pipeline with values and then only enable the accumulator)
    logic stall;

    logic clear_cntrMem, enable_cntrWriteMem;        //Counter that handles (produces addresses) to write to both memories
    logic clear_cntrMac, enable_cntrMac;             //Counter that handles delay in MAC arithmetic for output_valid signals just for initial stages until the pipeline if full
    logic clear_cntrMemX, enable_cntrReadMem_X;      //Counter that handles (produces addresses) to read from vector memory (X)
    logic clear_cntrMemW, enable_cntrReadMem_W;      //Counter that handles (produces addresses) to read from matrix memory (W)

    logic [WIDTH_MEM_WR_W-1:0] countMemOut, countMemOutDelay;
    logic [WIDTH_MAC_X-1:0] countMacOut;
    logic [WIDTH_MEM_READ_X-1:0] countMem_X_Out;
    logic [WIDTH_MEM_WR_W-1:0] countMem_W_Out;

    logic delay_enable_reg1, delay_enable_reg2, delay_en_acc;

    // always_ff @( posedge clk ) begin
    //     if(reset) begin
    //         operationState <= 0;
    //     end
    //     else if(~operationState && countMemState && countMemOut == 3) begin
    //         operationState <= 1;
    //     end
    //     else if(operationState && countMem_W_Out == 8 && output_ready && output_valid) begin
    //         operationState <= 0;
    //     end
        
    // end

    always_ff @( posedge clk ) begin
        if(reset) begin
            delay_enable_reg1 <= 0;
            delay_en_acc <= 0;
        end
        else if(enable_cntrReadMem_X) begin
            delay_enable_reg1 <= enable_cntrReadMem_X;
            delay_enable_reg2 <= delay_enable_reg1;
        end
        else begin
            delay_enable_reg1 <= 0;
            delay_enable_reg2 <= 0;
        end

        if(output_valid && output_ready) begin
            delay_en_acc <= 1;
        end
        else
            delay_en_acc <= 0;
        
    end



    always_comb begin
        
        //TODO add enable_pipeline_multipliesr = ~stall
        if(reset) begin
            input_ready = 1;
            countMemState = 0;
            operationState = 0;
            output_valid = 0;
        end
        else if(~operationState) begin   //write mode
            addr_w = countMemOut;
            addr_x = countMemOut;
            if(input_valid && input_ready) begin
                enable_cntrWriteMem = 1;
                clear_cntrMem = 0;
                if(~countMemState) begin
                    wr_en_w = 1; //enable write W
                    if(countMemOut == 9) begin
                        wr_en_w = 0;     //disable write W
                        clear_cntrMem = 1;     //enable clear signal
                        countMemState = 1;                              
                    end          
                end
                if(countMemState) begin
                    wr_en_x = 1;  //enable write X 
                    if(countMemOut == 3) begin
                        wr_en_x = 0;     //disable write X
                        clear_cntrMem = 1;        //enable clear signal
                        countMemState = 0;
                        input_ready = 0; //not ready since we are gonna read
                        initial_enable = 1;
                        operationState = 1;
                    end
                end
            end

            else begin
                enable_cntrWriteMem = 0; //disable write address counter
            end
        end

        else if(operationState) begin  //read mode
            addr_x = countMem_X_Out;
            addr_w = countMem_W_Out;

            //clear_cntrMac = 0;
            clear_cntrMemX = 0;
            clear_cntrMemW = 0;
            //clear_acc = 0;
            clear_reg = 0;
            //TODO clear pipeline multiplier (connect this clear signal to the reset signal of the DW multiplier since it doesn't have a separate clear signal)
            
            enable_cntrReadMem_X = 1;
            enable_cntrReadMem_W = 1;
            enable_cntrMac = 1;

            en_pipeline_reg = 1;
            //en_acc = 0;

            if(countMem_X_Out == 2 && ~output_valid) begin
                enable_cntrReadMem_X = 0;
                clear_cntrMemX = 1;
            end
            else if(countMem_X_Out == 0) begin
                enable_cntrReadMem_X = 1;
            end

            if(countMacOut == 2 && initial_enable) begin
                // initial_enable = 0;
                en_acc = 1;
                clear_cntrMac = 1;
            end
            else if(countMacOut == 0 && ~initial_enable) begin
                clear_cntrMac = 0;
                enable_cntrMac = 0; //We don't need the MAC counter anymore after the inital set values because the pipeline is now full
            end

            if(count == 3) begin
                output_valid = 1;
                initial_enable = 0;
            end

            if(count == 2) begin
                enable_cntrReadMem_X = 0;
                enable_cntrReadMem_W = 0;
            end

            if(~initial_enable && count == 2) begin
                //en_acc = 0;
                en_pipeline_reg = 1;
                //TODO disable pipeliens multiplers as well
                enable_cntrReadMem_X = 0;
                enable_cntrReadMem_W = 0;
            end

            if(output_valid && ~output_ready) begin
                en_acc = 0;
                en_pipeline_reg = 0;
                //TODO disable pipeliens multiplers as well
                enable_cntrReadMem_X = 0;
                enable_cntrReadMem_W = 0;
            end
            else if(output_valid && output_ready) begin
                clear_acc = delay_en_acc;
                //output_valid = 0;
                en_acc = 0;
                en_pipeline_reg = 0;
                //TODO disable pipeliens multiplers as well
                enable_cntrReadMem_X = delay_en_acc;
                enable_cntrReadMem_W = delay_en_acc;
                clear_cntrMemX = 0;
                if(output_data == 0) begin
                    output_valid = 0;
                end
            end

            if(output_data == 0 && ~initial_enable) begin
                clear_acc = 0;
                en_acc = 1;
                en_pipeline_reg = delay_enable_reg2;
                //TODO enable pipeliens multiplers as well
                //enable_cntrReadMem_X = 1;
                //enable_cntrReadMem_W = 1;
                
            end
        end
        else begin
            //output_valid = 0;
            en_acc = 0;
            en_pipeline_reg = 0;
            enable_cntrReadMem_X = 0;
            enable_cntrReadMem_W = 0;
        end
    end

    // always_ff @( posedge clk ) begin
    //     if(reset || operationState) begin       //enable on read mode   //|| (output_valid && ~output_ready)
    //         en_acc <= 0;
    //         clear_acc <= 0;
    //         operationState <= 0;
    //         countMemState <= 0;
    //         output_valid <= 0;
    //         delay_output_valid <= 0;
    //         enable_cntrReadMem_W <= 1;
    //         enable_cntrReadMem_X <= 1;
    //         enable_cntrMac <= 1;
            
    //     end
    //     if(~countMemState && countMemOut == 9) begin
    //         countMemState <= 1;;  
    //     end
    //     else if(countMemState && countMemOut == 3) begin
    //         countMemState <= 0;
    //         operationState <= 1;
    //     end
    //     if(operationState) begin
    //         //output_valid <= 0;
            
            
    //         if(enable_cntrMac) begin
    //             en_acc <= 1;
    //         end
    //         if(count == 2) begin
    //             output_valid <= 1;
    //             //output_valid <= delay_output_valid;
    //             enable_cntrReadMem_W <= 0;
    //             enable_cntrReadMem_X <= 0;
    //             enable_cntrMac <= 0;
    //         end
    //         else if(output_valid && output_ready) begin
    //             output_valid <= 0;
    //             //output_valid <= delay_output_valid;
    //             clear_acc <= 1;
    //             enable_cntrReadMem_W <= 1;
    //             enable_cntrReadMem_X <= 1;
    //             enable_cntrMac <= 1;
    //         end
    //         else begin
    //             // enable_cntrReadMem_W <= 1;
    //             // enable_cntrReadMem_X <= 1;
    //             // enable_cntrMac <= 1;
    //             clear_acc <= 0;
    //         end
            
    //     end
        
    // end
    // always_ff @( posedge clk ) begin
    //     if(en_acc)
    //         delay_en_acc <= 1;
        
    // end




    // always_comb begin : cntrMemControllerCombinational
        
    //     if(reset) begin
    //         enable_cntrWriteMem = 0;
    //         countMemState = 0;
    //         countMacState = 0;
    //         enable_cntrReadMem_X = 0;
    //         enable_cntrReadMem_W = 0;
    //         enable_cntrWriteMem = 0;
    //         input_ready = 1; 
    //         wr_en_w = 0;
    //         wr_en_x = 0;
    //     end
    //     if(countMacOut == 3)begin
    //         output_valid = 1;
    //         clear_cntrMac = 1;
    //         countMacState = countMacState + 1;
    //     end
    //     if(countMacState == 3)begin
    //         en_acc = 0;
    //         enable_cntrReadMem_W = 0;
    //         enable_cntrReadMem_X = 0;
    //         input_ready = 1;
    //     end
    //     if(~output_ready && output_valid) begin      // && (countMemOut == countMem_W_Out) 
    //         wr_en_w = 0;
    //         wr_en_x = 0;
    //         input_ready = 0; 
            
    //     end
    //     else if(input_valid && input_ready && ~enable_cntrReadMem_W && ~enable_cntrReadMem_X) begin
    //         if(~countMemState) begin
    //             wr_en_w = 1;
    //             enable_cntrWriteMem = 1;
    //             addr_w = countMemOut;
    //             clear_cntrMem = 0;
    //             if(countMemOut == 9) begin //We have written all the 9 values of the matrix
    //                 clear_cntrMem = 1;
    //                 countMemState = ~countMemState;
    //                 enable_cntrWriteMem = 0;
    //                 enable_cntrReadMem_X = 0;
    //                 wr_en_w = 0;
    //             end
    //             else begin
    //                 //clear_cntrMem = 0;
    //                 countMemState = countMemState;
    //             end
    //         end
    //         else if(countMemState) begin
    //             wr_en_x = 1;
    //             enable_cntrWriteMem = 1;
    //             clear_cntrMem = 0;
    //             addr_x = countMemOut;
    //             if(countMemOut == 3) begin      //We have written all the 3 values of the vector
    //                 clear_cntrMem = 1;
    //                 enable_cntrWriteMem = 0;        //TODO clear_cntrMem should always be the opposite of this so do some optimization like clear_cntrMem - ~enable_cntrWriteMem
    //                 wr_en_x = 0;
    //                 wr_en_w = 0;
    //                 enable_cntrReadMem_X = 1;
    //                 enable_cntrReadMem_W = 1;
    //                 enable_cntrMac = 1;
    //                 input_ready = 0;
    //                 countMemState = ~countMemState;
    //             end
    //             else begin
    //                 //clear_cntrMem = 0;
    //                 countMemState = countMemState;
    //             end
    //         end
    //     end
    //     else if(~input_valid) begin
    //         enable_cntrWriteMem = 0;
    //     end
        
    //     if(output_valid) begin
    //         if(output_ready) begin
    //             //read
    //             enable_cntrMac = 1;
    //             input_ready = 0;
                

    //             en_acc = 1;
    //             enable_cntrReadMem_W = 1;
    //             addr_w = countMem_W_Out;

    //             enable_cntrReadMem_X = 1;
    //             addr_x = countMem_X_Out;

    //             output_valid = 0;


    //         end
    //         else begin
    //             //don't read
    //             enable_cntrWriteMem = 0;
    //             enable_cntrReadMem_X = 0;
    //             en_acc = 0;
    //             enable_cntrMac = 0;
    //             //TODO stall pipelined multiplier's enable signal as well
    //         end
    //     end
    //     else if(~output_valid) begin
    //         //read
    //         //clear_cntrMem = 1;
    //         enable_cntrMac = 1;
    //         input_ready = 0;
    //         //countMemState = ~countMemState;

    //         en_acc = 1;
    //         enable_cntrReadMem_W = 1;
    //         addr_w = countMem_W_Out;

    //         enable_cntrReadMem_X = 1;
    //         addr_x = countMem_X_Out;
    //     end
    //     else begin
    //         //enable_cntrReadMem_W = 0;
    //         // enable_cntrReadMem_X = 0;
    //         // enable_cntrWriteMem = 0;
    //         // input_ready = 1; 
    //         // wr_en_w = 0;
    //         // wr_en_x = 0;
    //     end
        
    // end

    // always_ff @( posedge clk ) begin
    //     if(reset) begin
    //         clear_cntrMem <= 0;
    //     end
    //     if((~countMemState && countMemOut == 9) || (countMemState && countMemOut == 3)) begin
    //         clear_cntrMem <= 1;
    //     end
    //     else
    //         clear_cntrMem <= 0;
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