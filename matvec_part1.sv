module Controller(clk, reset, input_valid, output_ready, addr_x, wr_en_x, addr_w, wr_en_w, clear_acc, en_acc, input_ready, output_valid);

    parameter ADDR_X_SIZE = 2;
    parameter ADDE_W_SIZE = 4;
    input clk, reset, input_valid, output_ready;
    output logic input_ready, output_valid;

    output logic [ADDR_X_SIZE-1:0] addr_x;  
    output logic [ADDE_W_SIZE-1:0] addr_w;
    output logic wr_en_x, wr_en_w, clear_acc, en_acc;    

    logic countMemState;        //State that keeps track of weather the counter is outpitting addresses for the matrix memory or the vector memory.     

    logic clear_cntrMem, enable_cntrMem, countMemOut;
    logic clear_cntrMac, enable_cntrMac, countMacOut;
    logic clear_cntrMemX, enable_cntrMemX, countMem_X_Out;
    logic clear_cntrMemW, enable_cntrMemW, countMem_W_Out;

    always_ff @( posedge clk ) begin : cntrMemController
        if(reset) begin
            countMemState <= 0;
           
        end
        if(input_valid && input_ready && ~countMemState) begin
            enable_cntrMem <= 1;
            wr_en_w <= 1;
            addr_w <= countMemOut;
            if(countMemOut == 8) begin //We have written all the 9 values of the matrix
                clear_cntrMem <= 1;
                countMemState <= ~countMemState;
            end
        end
        else if(input_valid && input_ready && countMemState) begin     //We are done reading the 9 values to matrix, now we have to start reading the 3 vector values
            enable_cntrMem <= 1;
            wr_en_x <= 1;
            addr_x <= countMemOut[1:0];     //Vector is 3x1 matrix, so it requires jsut 3 addresses. Since we are using the same counter for W and X, just take the 2 LSB bits to count to 3
            if(countMemOut == 2) begin      //We have read all the 3 values of the vector
                clear_cntrMem <= 1;
                countMemState <= ~countMemState;
            end
        end

        wr_en_w <= 0;
        wr_en_x <= 0;           
    end

    always_ff @( posedge clk ) begin : cntrMemReadController        // Block for for controlling the 2 counters that are used to produce memory addresses to read form X and W memories
        if(output_valid) begin
            if(output_ready) begin
                //read
                enable_cntrMemW <= 1;
                addr_w <= countMem_W_Out;

                enable_cntrMemX <= 1;
                addr_x <= countMem_X_Out;
            end
            else begin
                //don't read
                enable_cntrMemW <= 0;
                enable_cntrMemX <= 0;
                en_acc <= 0;
                //TODO stall pipelined multiplier's enable signal as well
            end
        end
        else begin
            //read
            enable_cntrMemW <= 1;
            addr_w <= countMem_W_Out;

            enable_cntrMemX <= 1;
            addr_x <= countMem_X_Out;
        end
    end

    always_ff @( posedge clk ) begin : cntrMacController
        if(countMacOut == 3) begin
            output_valid <= 1;
        end
        if(output_valid && output_ready) begin
            en_acc <= 0;
            clear_acc <= 1;
            output_valid <= ~output_valid;
        end
        en_acc <= 1;
        
    end




    Counter cntrMem #(4)(clk, reset, clear_cntrMem, enable_cntrMem, countMemOut);
    Counter cntrMac #(2)(clk, reset, clear_cntrMac, enable_cntrMac, countMacOut);
    Counter cntrMemX #(2)(clk, reset, clear_cntrMemX, enable_cntrMemX, countMem_X_Out);
    Counter cntrMemW #(4)(clk, reset, clear_cntrMemW, enable_cntrMemW, countMem_W_Out);

endmodule

module Counter(clk, reset, clear, enable, countOut);
    parameter WIDTH = 4;
    input clk, reset, clear, enable;
    logic [WIDTH-1:0] countIn;
    output logic countOut[WIDTH-1:0];


    always_ff @( posedge clk ) begin
        if(reset || clear)
            countOut <= 0;
        else if(enable) begin
            countOut <= countOut + 1;
        end        
    end
    
    
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

    Controller #(2, 4)(clk, reset, input_valid, output_ready, addr_x, wr_en_x, addr_w, wr_en_w, clear_acc, en_acc, input_ready, output_valid);

    memory vectorMem(clk, input_data, vectorMem_data_out, addr_x, wr_en_x );
    memory matrixMem(clk, input_data, matrixMem_data_out, addr_w, wr_en_w);

    

    part4b_mac macUnit(clk, reset, vectorMem_data_out, matrixMem_data_out, output_data );

endmodule