# Logic Level Synthesis of 2-bit ALU

Project report: *Logic Level Synthesis of 2-bit ALU*, submitted by Anuj Bajpai,
Jyoti, Devansh Panwar, and Devesh Doshi — Dept. of ECE, Faculty of Technology,
University of Delhi (Session 2025–2026), under the guidance of Dr. Sweta Rani
and Dr. Khushwant Sehra.

A 2-bit ALU implemented in Verilog HDL, supporting addition, subtraction, AND,
OR, XOR, multiplication, and division (with divide-by-zero handling). Two
adder architectures are compared: Ripple Carry Adder (RCA) and Carry
Lookahead Adder (CLA).

## Structure

```
alu-project/
├── rtl/
│   ├── alu_2bit.v      # RCA-based ALU (behavioural)
│   └── alu_cla.v       # CLA-based ALU (adder path uses carry lookahead)
├── tb/
│   ├── tb_alu.v        # Testbench for the RCA-based ALU
│   └── tb_alu_cla.v    # Testbench for the CLA-based ALU
├── docs/
│   └── SEC_ALU_.pdf    # Full project report (source doc)
└── README.md
```

## Note on the CLA module

The project report documents a CLA-based ALU (Chapter 5) — its gate-level
schematic and final GDS chip layout are both in the report — but the actual
`alu_cla` RTL source text was missing from the extracted report/repo (only
the testbenches survived). `rtl/alu_cla.v` here is a reconstruction that
matches the interface `tb/tb_alu_cla.v` expects (`A, B, opcode -> result,
remainder, valid, error`) and mirrors the Generate/Propagate carry lookahead
logic described in the report: only the addition path uses the CLA adder
(subtraction reuses it via 2's complement); AND/OR/XOR/multiply/divide are
unchanged from `alu_2bit.v`, with a `remainder` output added for division.
It has been verified in simulation against the values in the report
(e.g. 3+3=6, 3×3=9, divide-by-zero sets `error`).

## Simulating (Icarus Verilog + GTKWave)

```bash
# RCA-based ALU
iverilog -o sim_rca rtl/alu_2bit.v tb/tb_alu.v
vvp sim_rca
gtkwave dump.vcd

# CLA-based ALU
iverilog -o sim_cla rtl/alu_cla.v tb/tb_alu_cla.v
vvp sim_cla
gtkwave cla_dump.vcd
```

## Design flow (RTL → GDSII)

Icarus Verilog (simulation) → GTKWave (waveform analysis) → Yosys (logic
synthesis, SKY130 std-cell mapping) → OpenLane/OpenROAD (floorplanning, power
planning, placement, CTS, routing) → Magic VLSI / Netgen (DRC/LVS) → KLayout
(GDSII visualization).

See the full report in `docs/SEC_ALU_.pdf` for the gate-level schematics,
RCA vs. CLA comparison table, and final chip layouts.
