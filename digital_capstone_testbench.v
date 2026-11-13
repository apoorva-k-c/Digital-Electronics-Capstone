`timescale 1ns/1ps
module digital_capstone_testbench;
    reg clk = 0;
    reg reset = 1;
    wire [2:0] count;
    wire [2:0] traffic_state;
    wire A_green, A_yellow, A_red, B_green, B_yellow, B_red;

    mod6_synchronous_counter u_counter (
        .clk(clk), .reset(reset), .count(count)
    );

    two_road_traffic_light u_traffic (
        .clk(clk), .reset(reset), .state(traffic_state),
        .A_green(A_green), .A_yellow(A_yellow), .A_red(A_red),
        .B_green(B_green), .B_yellow(B_yellow), .B_red(B_red)
    );

    always #5 clk = ~clk;

    integer i;
    initial begin
        $display("time | MOD6 count | traffic state | A(GYR) | B(GYR)");
        #12 reset = 0;
        for (i = 0; i < 12; i = i + 1) begin
            @(posedge clk); #1;
            $display("%4t | %b (%0d) | %b | %b%b%b | %b%b%b",
                $time, count, count, traffic_state,
                A_green, A_yellow, A_red, B_green, B_yellow, B_red);
        end
        $finish;
    end
endmodule
