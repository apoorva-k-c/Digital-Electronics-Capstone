// Digital Electronics Capstone: MOD-6 Counter + Two-Road Traffic-Light Moore FSM
// Synthesizable Verilog. Both designs use rising-edge-triggered state registers.

module mod6_synchronous_counter (
    input  wire       clk,
    input  wire       reset,
    output reg  [2:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 3'b000;
        else if (count == 3'b101)
            count <= 3'b000;
        else if (count >= 3'b110)
            count <= 3'b000;
        else
            count <= count + 3'b001;
    end
endmodule

module two_road_traffic_light (
    input  wire       clk,
    input  wire       reset,
    output reg  [2:0] state,
    output reg        A_green,
    output reg        A_yellow,
    output reg        A_red,
    output reg        B_green,
    output reg        B_yellow,
    output reg        B_red
);
    localparam S0 = 3'b000; // A green, B red
    localparam S1 = 3'b001; // A yellow, B red
    localparam S2 = 3'b010; // all red clearance
    localparam S3 = 3'b011; // A red, B green
    localparam S4 = 3'b100; // A red, B yellow
    localparam S5 = 3'b101; // all red clearance

    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= S0;
        else begin
            case (state)
                S0: state <= S1;
                S1: state <= S2;
                S2: state <= S3;
                S3: state <= S4;
                S4: state <= S5;
                S5: state <= S0;
                default: state <= S0;
            endcase
        end
    end

    // Moore outputs: outputs depend only on the registered current state.
    always @* begin
        A_green  = 1'b0; A_yellow = 1'b0; A_red = 1'b1;
        B_green  = 1'b0; B_yellow = 1'b0; B_red = 1'b1;
        case (state)
            S0: begin A_green = 1'b1; A_red = 1'b0; end
            S1: begin A_yellow = 1'b1; A_red = 1'b0; end
            S2: begin end
            S3: begin B_green = 1'b1; B_red = 1'b0; end
            S4: begin B_yellow = 1'b1; B_red = 1'b0; end
            S5: begin end
            default: begin end
        endcase
    end
endmodule
