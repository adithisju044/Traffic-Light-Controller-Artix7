`timescale 1ns / 1ps

module tb_traffic_light_top;

    // Short timing values make simulation complete quickly.
    localparam integer CLK_FREQ_HZ = 10;
    localparam integer GREEN_SEC   = 2;
    localparam integer YELLOW_SEC  = 1;
    localparam integer CLEAR_SEC   = 1;

    reg clk;
    reg reset;

    wire ns_red, ns_yellow, ns_green;
    wire ew_red, ew_yellow, ew_green;

    traffic_light_top #(
        .CLK_FREQ_HZ(CLK_FREQ_HZ),
        .GREEN_SEC(GREEN_SEC),
        .YELLOW_SEC(YELLOW_SEC),
        .CLEAR_SEC(CLEAR_SEC)
    ) dut (
        .clk(clk),
        .reset(reset),
        .ns_red(ns_red),
        .ns_yellow(ns_yellow),
        .ns_green(ns_green),
        .ew_red(ew_red),
        .ew_yellow(ew_yellow),
        .ew_green(ew_green)
    );

    // 10 ns clock period.
    initial clk = 1'b0;
    always #5 clk = ~clk;

    task check_outputs;
        input expected_ns_red;
        input expected_ns_yellow;
        input expected_ns_green;
        input expected_ew_red;
        input expected_ew_yellow;
        input expected_ew_green;
        begin
            if ({ns_red, ns_yellow, ns_green,
                 ew_red, ew_yellow, ew_green} !==
                {expected_ns_red, expected_ns_yellow,
                 expected_ns_green, expected_ew_red,
                 expected_ew_yellow, expected_ew_green}) begin
                $display("ERROR at time %0t: unexpected output pattern", $time);
                $display("Observed: NS=%b%b%b EW=%b%b%b",
                         ns_red, ns_yellow, ns_green,
                         ew_red, ew_yellow, ew_green);
                $fatal(1, "Traffic light output check failed.");
            end

            if (ns_green && ew_green)
                $fatal(1, "Safety violation: both roads are green.");
        end
    endtask

    initial begin
        $dumpfile("traffic_light_waveform.vcd");
        $dumpvars(0, tb_traffic_light_top);

        reset = 1'b1;
        repeat (2) @(posedge clk);
        @(negedge clk);
        reset = 1'b0;

        // State 1: North-South green, East-West red.
        check_outputs(1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0);
        repeat (GREEN_SEC * CLK_FREQ_HZ) @(posedge clk);
        #1;
        check_outputs(1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0);

        // State 2: North-South yellow, East-West red.
        repeat (YELLOW_SEC * CLK_FREQ_HZ) @(posedge clk);
        #1;
        check_outputs(1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0);

        // State 3: All-red clearance.
        repeat (CLEAR_SEC * CLK_FREQ_HZ) @(posedge clk);
        #1;
        check_outputs(1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1);

        // State 4: East-West green, North-South red.
        repeat (GREEN_SEC * CLK_FREQ_HZ) @(posedge clk);
        #1;
        check_outputs(1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0);

        // State 5: East-West yellow, North-South red.
        repeat (YELLOW_SEC * CLK_FREQ_HZ) @(posedge clk);
        #1;
        check_outputs(1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0);

        // State 6: All-red clearance, then cycle back to NS green.
        repeat (CLEAR_SEC * CLK_FREQ_HZ) @(posedge clk);
        #1;
        check_outputs(1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0);

        $display("PASS: All traffic-light phases and safety checks completed.");
        $finish;
    end

endmodule
