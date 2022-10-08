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

module Controller(clk, reset, input_valid, output_ready, addr_x, wr_en_x, addr_w, wr_en_w, clear_acc, en_acc, input_ready, output_valid);

    parameter ADDR_X_SIZE = 2;
    parameter ADDE_W_SIZE = 4;
    parameter WIDTH_MEM_WR_W = 4;           //Size of counter that writes to memory and reads from memory W (cntrMem & cntrMemW)
    parameter WIDTH_MAC_X = 2;              //Size of counter that handles MAC delay and reads from memory X (cntrMac & cntrMemX)
    input clk, reset, input_valid, output_ready;
    output logic input_ready, output_valid;

    output logic [ADDR_X_SIZE-1:0] addr_x;  
    output logic [ADDE_W_SIZE-1:0] addr_w;
    output logic wr_en_x, wr_en_w, clear_acc, en_acc;    

    logic countMemState;        //State that keeps track of weather the counter is outpitting addresses for the matrix memory or the vector memory.     

    logic clear_cntrMem, enable_cntrWriteMem;        //Counter that handles (produces addresses) to write to both memories
    logic clear_cntrMac, enable_cntrMac;        //Counter that handles delay in MAC arithmetic
    logic clear_cntrMemX, enable_cntrReadMem_X;      //Counter that handles (produces addresses) to read from both vector memory (X)
    logic clear_cntrMemW, enable_cntrReadMem_W;      //Counter that handles (produces addresses) to read from both vector memory (W)

    logic [WIDTH_MEM_WR_W-1:0] countMemOut, countMemOutDelay;
    logic [WIDTH_MAC_X-1:0] countMacOut;
    logic [WIDTH_MAC_X-1:0] countMem_X_Out;
    logic [WIDTH_MEM_WR_W-1:0] countMem_W_Out;

    always_comb begin : cntrMemControllerCombinational
        if(reset) begin
            enable_cntrWriteMem = 0;
            countMemState = 0;
        end
        else if(~output_ready && output_valid) begin      // && (countMemOut == countMem_W_Out) 
            wr_en_w = 0;
            wr_en_x = 0;
            input_ready = 0; 
            
        end
        else if(input_valid && input_ready) begin
            if(~countMemState) begin
                wr_en_w = 1;
                enable_cntrWriteMem = 1;
                addr_w = countMemOut;
                if(countMemOut == 9) begin //We have written all the 9 values of the matrix
                    clear_cntrMem = 1;
                    countMemState = ~countMemState;
                    enable_cntrWriteMem = 0;
                    enable_cntrReadMem_X = 0;
                    wr_en_w = 0;
                end
                else begin
                    //clear_cntrMem = 0;
                    countMemState = countMemState;
                end
            end
            else if(countMemState) begin
                wr_en_x = 1;
                enable_cntrWriteMem = 1;
                addr_x = countMemOut;
                if(countMemOut == 3) begin      //We have written all the 3 values of the vector
                    clear_cntrMem = 1;
                    wr_en_x = 0;
                    enable_cntrReadMem_X = 1;
                    countMemState = ~countMemState;
                end
                
                    //clear_cntrMem = 0;

            end
        end
        else if(output_valid) begin
            if(output_ready) begin
                //read
                en_acc = 1;
                enable_cntrWriteMem = 1;
                addr_w = countMem_W_Out;

                enable_cntrReadMem_X = 1;
                addr_x = countMem_X_Out;
            end
            else begin
                //don't read
                enable_cntrWriteMem = 0;
                enable_cntrReadMem_X = 0;
                en_acc = 0;
                //TODO stall pipelined multiplier's enable signal as well
            end
        end
        else if(~output_valid) begin
            //don't read
            en_acc = 0;
            enable_cntrWriteMem = 0;
            addr_w = countMemOut;

            enable_cntrReadMem_X = 0;
            addr_x = countMem_X_Out;
        end
        // else if(countMemState && countMemOut == 3) begin
        //     //enable_cntrReadMem_W = 1;
        //     enable_cntrWriteMem = 1;
        //     enable_cntrReadMem_X = 1;
        //     countMemState = ~countMemState;
        // end
        // else if(~countMemState && countMemOut == 8) begin
        //     enable_cntrWriteMem = 0;
        //     enable_cntrReadMem_X = 0;
        // end
        else begin
            //enable_cntrReadMem_W = 0;
            enable_cntrReadMem_X = 0;
            enable_cntrWriteMem = 0;
            input_ready = 1; 
            wr_en_w = 0;
            wr_en_x = 0;
        end
        
    end

    // always_comb begin : cntrMemReadControllerCombinational
    //     if(reset) begin
            
    //     end
    //     // else if(output_valid) begin
    //     //     if(output_ready) begin
    //     //         //read
    //     //         en_acc = 1;
    //     //         enable_cntrWriteMem = 1;
    //     //         addr_w = countMem_W_Out;

    //     //         enable_cntrReadMem_X = 1;
    //     //         addr_x = countMem_X_Out;
    //     //     end
    //     //     else begin
    //     //         //don't read
    //     //         enable_cntrWriteMem = 0;
    //     //         enable_cntrReadMem_X = 0;
    //     //         en_acc = 0;
    //     //         //TODO stall pipelined multiplier's enable signal as well
    //     //     end
    //     // end
    //     // else begin
    //     //     //read
    //     //     en_acc = 1;
    //     //     enable_cntrWriteMem = 1;
    //     //     addr_w = countMemOut;

    //     //     enable_cntrReadMem_X = 1;
    //     //     addr_x = countMem_X_Out;
    //     // end

    //     // if(countMemState && countMemOut == 2) begin
    //     //     //enable_cntrReadMem_W = 1;
    //     //     enable_cntrWriteMem = 1;
    //     //     enable_cntrReadMem_X = 1;
    //     //     countMemState = ~countMemState;
    //     // end
    //     // else if(~countMemState && countMemOut == 8) begin
    //     //     enable_cntrWriteMem = 0;
    //     //     enable_cntrReadMem_X = 0;
    //     // end
    // end
    

    // always_ff @( posedge clk ) begin : cntrMemController
    //     if(reset) begin
    //         input_ready <= 1;
    //         //countMemState <= 0;
    //         //enable_cntrWriteMem <= 0;
    //         //clear_cntrMem <= 1;
           
    //     end
    //     else if(~output_ready && output_valid && (countMemOut == countMem_W_Out) && ~countMemState) begin
    //         //wr_en_w <= 0;
    //         input_ready <= 0;
    //     end

    //     else if(input_valid && input_ready && ~countMemState) begin
    //         //enable_cntrWriteMem <= 1;
    //         //wr_en_w <= 1;
    //         //countMemOutDelay <= countMemOut;            
    //         // if(countMemOut == 8) begin //We have written all the 9 values of the matrix
    //         //     clear_cntrMem <= 1;
    //         //     countMemState <= ~countMemState;
    //         // end
    //         // else 
    //         //     clear_cntrMem <= 0;
    //     end
    //     else if(input_valid && input_ready && countMemState) begin     //We are done reading the 9 values to matrix, now we have to start reading the 3 vector values
    //         //enable_cntrWriteMem <= 1;
    //         // wr_en_x <= 1;
    //         // addr_x <= countMemOut;     //Vector is 3x1 matrix, so it requires jsut 3 addresses. Since we are using the same counter for W and X, just take the 2 LSB bits to count to 3
    //         // if(countMemOut == 2) begin      //We have read all the 3 values of the vector
    //         //     clear_cntrMem <= 1;
    //         // end
    //         // else
    //         //     clear_cntrMem <= 0;
    //     end
    //     else begin
    //        // wr_en_w <= 0;
    //         //wr_en_x <= 0;
    //         input_ready <= 1;          
    //     end          
    // end


    // always_ff @( posedge clk ) begin : cntrMemReadController        // Block for for controlling the 2 counters that are used to produce memory addresses to read form X and W memories
    //     if(reset) begin
    //         // clear_cntrMemX <= 1;
    //         // clear_cntrMemW <= 1;
    //     end
        // if(output_valid) begin
        //     if(output_ready) begin
        //         //read
        //         enable_cntrReadMem_W <= 1;
        //        // addr_w <= countMem_W_Out;

        //         enable_cntrReadMem_X <= 1;
        //         //addr_x <= countMem_X_Out;
        //     end
        //     else begin
        //         //don't read
        //         enable_cntrReadMem_W <= 0;
        //         enable_cntrReadMem_X <= 0;
        //         en_acc <= 0;
        //         //TODO stall pipelined multiplier's enable signal as well
        //     end
        // end
        // else begin
        //     //read
        //     enable_cntrReadMem_W <= 1;
        //     //addr_w <= countMem_W_Out;

        //     enable_cntrReadMem_X <= 1;
        //     //addr_x <= countMem_X_Out;
        // end

    //     if(countMemState && countMemOut == 2) begin
    //         enable_cntrReadMem_W <= 1;
    //         enable_cntrReadMem_X <= 1;
    //         //countMemState <= ~countMemState;
    //     end
    //     else if(~countMemState && countMemOut == 8) begin
    //         enable_cntrReadMem_W <= 0;
    //         enable_cntrReadMem_X <= 0;
    //     end
    // end

    // always_ff @( posedge clk ) begin : cntrMacController
    //     if(reset) begin
    //         clear_cntrMac <= 1;
    //         clear_acc <= 1;
    //     end
    //     if(countMacOut == 3) begin
    //         output_valid <= 1;
    //     end
    //     else
    //         output_valid <= 0;
    //     if(output_valid && output_ready) begin
    //         en_acc <= 0;
    //         clear_acc <= 1;
    //     end
    //     en_acc <= 0;
        
    // end


    Counter #(4) cntrMem (clk, reset, clear_cntrMem, enable_cntrWriteMem, countMemOut);
    Counter #(2) cntrMac (clk, reset, clear_cntrMac, enable_cntrMac, countMacOut);
    Counter #(2) cntrMemX (clk, reset, clear_cntrMemX, enable_cntrReadMem_X, countMem_X_Out);
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
    logic clear_acc, en_acc;
    logic en_multiplier;

    output logic signed [27:0] output_data;
    output logic output_valid, input_ready;

    Controller #(2, 4) controller(clk, reset, input_valid, output_ready, addr_x, wr_en_x, addr_w, wr_en_w, clear_acc, en_acc, input_ready, output_valid);

    memory #(14, 3) vectorMem(clk, input_data, vectorMem_data_out, addr_x, wr_en_x );
    memory  #(14, 9) matrixMem(clk, input_data, matrixMem_data_out, addr_w, wr_en_w);

    part4b_mac macUnit(clk, reset, en_acc, clear_acc, vectorMem_data_out, matrixMem_data_out, output_data);

endmodule