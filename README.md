# Traffic Light Controller using Verilog HDL and Artix-7 FPGA

A two-road traffic light controller designed using Verilog HDL and a finite-state machine (FSM). The RTL is intended for synthesis on an AMD/Xilinx Artix-7 FPGA using Vivado Design Suite.

## Project overview

The controller manages traffic flow between two directions:

- North-South (NS)
- East-West (EW)

It uses a six-phase finite-state machine, a programmable phase timer, and six active-high signal outputs.

## Features

- Six-phase FSM architecture
- Independent red, yellow, and green outputs for both roads
- All-red clearance interval between road changes
- Parameterized clock frequency and signal durations
- Active-high synchronous reset
- Verilog testbench with output and safety checks
- Waveform dump support for simulation

## Traffic signal sequence

| Phase | North-South | East-West |
|---|---|---|
| 1 | Green | Red |
| 2 | Yellow | Red |
| 3 | Red | Red |
| 4 | Red | Green |
| 5 | Red | Yellow |
| 6 | Red | Red |

The sequence repeats continuously.

## Default timing

The default RTL parameters assume a 100 MHz clock.

| Parameter | Default |
|---|---:|
| Clock frequency | 100 MHz |
| Green duration | 10 seconds |
| Yellow duration | 3 seconds |
| All-red clearance | 1 second |

The parameters `CLK_FREQ_HZ`, `GREEN_SEC`, `YELLOW_SEC`, and `CLEAR_SEC` can be changed when instantiating the module.

## Repository structure

```text
Traffic-Light-Controller-Artix7/
├── rtl/
│   └── traffic_light_top.v
├── sim/
│   └── tb_traffic_light_top.v
├── constraints/
│   └── README.md
├── docs/
│   └── EXPECTED_SEQUENCE.txt
├── .gitignore
└── README.md
```

## Top-level I/O

| Signal | Direction | Description |
|---|---|---|
| clk | Input | FPGA system clock |
| reset | Input | Active-high synchronous reset |
| ns_red | Output | North-South red signal |
| ns_yellow | Output | North-South yellow signal |
| ns_green | Output | North-South green signal |
| ew_red | Output | East-West red signal |
| ew_yellow | Output | East-West yellow signal |
| ew_green | Output | East-West green signal |

## Simulation

The testbench instantiates the controller with shortened timing parameters so the complete sequence can be examined quickly.

It checks the expected output patterns for each phase and verifies that both directions are never green simultaneously.

The testbench writes a waveform file named `traffic_light_waveform.vcd` when run in a compatible Verilog simulator.

Example with Icarus Verilog:

```bash
iverilog -g2012 -o traffic_tb rtl/traffic_light_top.v sim/tb_traffic_light_top.v
vvp traffic_tb
```

Open the generated waveform with GTKWave:

```bash
gtkwave traffic_light_waveform.vcd
```

## Vivado implementation

1. Create a new RTL project in Vivado.
2. Select the exact Artix-7 FPGA part used by the target board.
3. Add `rtl/traffic_light_top.v` as a design source.
4. Add `sim/tb_traffic_light_top.v` as a simulation source.
5. Add board-specific timing and pin constraints.
6. Set `traffic_light_top` as the top module.
7. Run behavioral simulation, synthesis, and implementation.
8. Generate the bitstream and program the FPGA if hardware is available.

**Board constraints:** Pin assignments are intentionally not guessed. Use the official master XDC for the exact FPGA board before attempting hardware implementation.

## Tools and technologies

- Verilog HDL
- AMD/Xilinx Vivado Design Suite (2025.2 target workflow)
- Artix-7 FPGA family
- Finite State Machine (FSM) design

## Project status

Source code and testbench are included. Hardware implementation and board-level testing should be performed on the intended Artix-7 development board.

## License

No license has been specified for this repository.
