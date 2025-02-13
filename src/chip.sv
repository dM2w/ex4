`default_nettype none

module my_chip (
    input logic [11:0] io_in, // Inputs to your chip
    output logic [11:0] io_out, // Outputs from your chip
    input logic clock,
    input logic reset // Important: Reset is ACTIVE-HIGH
);
    
    // Basic counter design as an example
    // TODO: remove the counter design and use this module to insert your own design
    // DO NOT change the I/O header of this design

    // wire [6:0] led_out;
    // assign io_out[6:0] = led_out;

    logic go, finish;
    logic [9:0] data_in;
    assign io_in[0] = go;
    assign io_in[1] = finish;
    assign io_in[11:2] = data_in;
   
    logic debug_error;
    logic [9:0] range;
    assign io_out[0] = debug_error;
    assign io_out[10:1] = range;
 
    logic [9:0] max, min;
    logic going;

    always_ff @(posedge clock, posedge reset) begin
        if (reset) begin
            debug_error <= 0;
            max <= 0;
            min <= {10{'b1}};
            range <= 0;
            going <= 0;
            
        end else begin
            if (go && finish) begin
                debug_error <= 1;
            end else if (!going && finish) begin
                debug_error <= 1;
            end else if (go) begin
                debug_error <= 0;
            end

            if (go && !going) begin
                // transist to find range
                going <= 1;
                max <= data_in;
                min <= data_in;
            end else if (going) begin
                if (finish) begin
                    range <= max - min;
                    going <= 0;
                end else begin
                    if (data_in > max) begin
                        max <= data_in;
                    end
                    if (data_in < min) begin
                        min <= data_in;
                    end
                end
            end
        end
    end

endmodule
