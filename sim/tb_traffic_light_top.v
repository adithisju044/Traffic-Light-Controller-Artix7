`timescale 1ns / 1ps
module tb_traffic_light_top;
 localparam integer CLK_FREQ_HZ=10, GREEN_SEC=2, YELLOW_SEC=1, CLEAR_SEC=1;
 reg clk=0, reset; wire ns_red,ns_yellow,ns_green,ew_red,ew_yellow,ew_green;
 traffic_light_top #(.CLK_FREQ_HZ(CLK_FREQ_HZ),.GREEN_SEC(GREEN_SEC),.YELLOW_SEC(YELLOW_SEC),.CLEAR_SEC(CLEAR_SEC)) dut (
 .clk(clk),.reset(reset),.ns_red(ns_red),.ns_yellow(ns_yellow),.ns_green(ns_green),.ew_red(ew_red),.ew_yellow(ew_yellow),.ew_green(ew_green));
 always #5 clk=~clk;
 task check; input [5:0] exp; begin
 if ({ns_red,ns_yellow,ns_green,ew_red,ew_yellow,ew_green} !== exp) $fatal(1,"Expected %b got %b",exp,{ns_red,ns_yellow,ns_green,ew_red,ew_yellow,ew_green});
 if(ns_green && ew_green) $fatal(1,"Both directions green");
 end endtask
 task ticks; input integer n; integer i; begin for(i=0;i<n;i=i+1) begin @(posedge clk); #1; end end endtask
 initial begin
 $dumpfile("traffic_light_waveform.vcd"); $dumpvars(0,tb_traffic_light_top);
 reset=1; ticks(2); @(negedge clk); reset=0; #1;
 check(6'b001100); ticks(GREEN_SEC*CLK_FREQ_HZ); check(6'b010100);
 ticks(YELLOW_SEC*CLK_FREQ_HZ); check(6'b100100); ticks(CLEAR_SEC*CLK_FREQ_HZ);
 check(6'b100001); ticks(GREEN_SEC*CLK_FREQ_HZ); check(6'b100010);
 ticks(YELLOW_SEC*CLK_FREQ_HZ); check(6'b100100); ticks(CLEAR_SEC*CLK_FREQ_HZ);
 check(6'b001100); $display("PASS: all six phases and safety checks passed."); $finish;
 end
endmodule
