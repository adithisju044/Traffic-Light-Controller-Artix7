# FPGA Constraints

This directory is reserved for the XDC constraints file for the exact Artix-7 development board.

Do not use guessed pin assignments.

Before programming hardware:

1. Identify the exact FPGA board and device part number.
2. Obtain the official master XDC file from the board manufacturer.
3. Map the clock, reset, and six traffic-light outputs to the correct package pins.
4. Set the correct clock period in the XDC file.
5. Review the board's I/O voltage standards and electrical requirements.

The RTL can be simulated without an XDC file. A board-specific XDC is required for physical FPGA implementation.
