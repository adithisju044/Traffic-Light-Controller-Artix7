# Four-Way Traffic Light Controller — Basys 3 FPGA

A parameterized Verilog finite-state-machine (FSM) traffic-light controller for the **Digilent Basys 3 (Artix-7 XC7A35T-1CPG236C)**, targeting **AMD Vivado 2025.2**.

## Overview

North and South share one signal group; East and West share the opposing group. The controller runs six phases:

1. North/South green; East/West red
2. North/South yellow; East/West red
3. All-red clearance
4. East/West green; North/South red
5. East/West yellow; North/South red
6. All-red clearance, then repeat

A synchronous active-high reset returns the controller to phase 1.

## Default timing

| Interval | Duration |
|---|---:|
| Green | 10 seconds |
| Yellow | 3 seconds |
| All-red clearance | 1 second |
| Clock | 100 MHz |

Timing parameters are configurable in the RTL.

## Repository layout

```
Traffic-Light-Controller-Artix7/
├── rtl/traffic_light_top.v
├── sim/tb_traffic_light_top.v
├── constraints/basys3_traffic_light.xdc
├── docs/architecture.md
├── docs/expected_sequence.txt
├── vivado/setup.md
├── LICENSE
├── .gitignore
└── README.md
```

## Basys 3 I/O

- Clock: W5, 100 MHz
- Reset: BTNC, U18, active-high
- Six output indicators: LED0–LED5

The XDC targets the Digilent Basys 3. Confirm the exact board model and revision before programming hardware.

## Simulation

With Icarus Verilog:

```bash
iverilog -g2012 -o traffic_tb rtl/traffic_light_top.v sim/tb_traffic_light_top.v
vvp traffic_tb
```

Expected final message: `PASS: all six phases and safety assertions passed.`

The testbench emits `traffic_light_waveform.vcd`, which can be opened with GTKWave.

## Vivado 2025.2

1. Create an RTL project.
2. Select the Basys 3 board, or device `xc7a35tcpg236-1`.
3. Add `rtl/traffic_light_top.v` as a design source.
4. Add `sim/tb_traffic_light_top.v` as a simulation source.
5. Add `constraints/basys3_traffic_light.xdc` as a constraints source.
6. Set `traffic_light_top` as design top and `tb_traffic_light_top` as simulation top.
7. Run behavioral simulation, synthesis, implementation, and Generate Bitstream.
8. Use Hardware Manager to program the Basys 3.

See [Vivado setup](vivado/setup.md).

## Hardware note

The six on-board LEDs are indicators, not powered traffic lamps. Use current-limiting resistors and suitable driver circuitry for external lamps. Never connect high-current loads directly to FPGA I/O pins.

## Verification status

RTL and testbench are provided. Vivado synthesis, implementation, bitstream generation, and physical board testing have not been run as part of this repository update; perform them locally before claiming hardware validation.

## License

MIT. See [LICENSE](LICENSE).
