# Vivado 2025.2 Setup

1. Create an RTL project in Vivado 2025.2.
2. Select the Basys 3 board, or part `xc7a35tcpg236-1`.
3. Add `rtl/traffic_light_top.v` as a Design Source.
4. Add `sim/tb_traffic_light_top.v` as a Simulation Source.
5. Add `constraints/basys3_traffic_light.xdc` as a Constraints source.
6. Set `traffic_light_top` as design top and `tb_traffic_light_top` as simulation top.
7. Run Behavioral Simulation and check all six output phases and the PASS message.
8. Run Synthesis and Implementation; review timing and DRC reports.
9. Generate Bitstream.
10. Open Hardware Manager, connect the Basys 3 over USB, and program the device.

Clock W5 is 100 MHz (10 ns). Reset is BTNC on U18, active-high. LEDs are indicators, not powered traffic lamps.
