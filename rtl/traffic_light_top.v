`timescale 1ns / 1ps

// Two-road traffic light controller using a six-state FSM.
// Default clock: 100 MHz. Timing parameters are in seconds.
module traffic_light_top #(
    parameter integer CLK_FREQ_HZ = 100_000_000,
    parameter integer GREEN_SEC   = 10,
    parameter integer YELLOW_SEC  = 3,
    parameter integer CLEAR_SEC   = 1
) (
    input  wire clk,
    input  wire reset,       // Active-high synchronous reset

    output reg  ns_red,
    output reg  ns_yellow,
    output reg  ns_green,

    output reg  ew_red,
    output reg  ew_yellow,
    output reg  ew_green
);

    localparam [2:0] NS_GREEN  = 3'd0,
                     NS_YELLOW = 3'd1,
                     CLEAR_1   = 3'd2,
                     EW_GREEN  = 3'd3,
                     EW_YELLOW = 3'd4,
                     CLEAR_2   = 3'd5;

    localparam integer GREEN_TICKS  = CLK_FREQ_HZ * GREEN_SEC;
    localparam integer YELLOW_TICKS = CLK_FREQ_HZ * YELLOW_SEC;
    localparam integer CLEAR_TICKS  = CLK_FREQ_HZ * CLEAR_SEC;

    reg [2:0] state;
    reg [31:0] timer_count;
    reg [31:0] phase_ticks;

    // Select the duration associated with the current FSM state.
    always @(*) begin
        case (state)
            NS_GREEN, EW_GREEN:
                phase_ticks = GREEN_TICKS;
            NS_YELLOW, EW_YELLOW:
                phase_ticks = YELLOW_TICKS;
            CLEAR_1, CLEAR_2:
                phase_ticks = CLEAR_TICKS;
            default:
                phase_ticks = CLEAR_TICKS;
        endcase
    end

    // State register and phase timer.
    always @(posedge clk) begin
        if (reset) begin
            state       <= NS_GREEN;
            timer_count <= 32'd0;
        end else if (timer_count >= phase_ticks - 1) begin
            timer_count <= 32'd0;

            case (state)
                NS_GREEN:  state <= NS_YELLOW;
                NS_YELLOW: state <= CLEAR_1;
                CLEAR_1:   state <= EW_GREEN;
                EW_GREEN:  state <= EW_YELLOW;
                EW_YELLOW: state <= CLEAR_2;
                CLEAR_2:   state <= NS_GREEN;
                default:   state <= NS_GREEN;
            endcase
        end else begin
            timer_count <= timer_count + 1'b1;
        end
    end

    // Decode the FSM state into traffic-light outputs.
    // Both directions are red during clearance states.
    always @(*) begin
        ns_red    = 1'b1;
        ns_yellow = 1'b0;
        ns_green  = 1'b0;

        ew_red    = 1'b1;
        ew_yellow = 1'b0;
        ew_green  = 1'b0;

        case (state)
            NS_GREEN: begin
                ns_red   = 1'b0;
                ns_green = 1'b1;
            end

            NS_YELLOW: begin
                ns_red    = 1'b0;
                ns_yellow = 1'b1;
            end

            EW_GREEN: begin
                ew_red   = 1'b0;
                ew_green = 1'b1;
            end

            EW_YELLOW: begin
                ew_red    = 1'b0;
                ew_yellow = 1'b1;
            end

            default: begin
                // Safe all-red output for CLEAR_1, CLEAR_2,
                // and any invalid state.
            end
        endcase
    end

endmodule
