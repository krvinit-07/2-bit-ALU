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
│   └── alu_2bit.v      # RCA-based ALU (behavioural)
├── tb/
│   ├── tb_alu.v        # Testbench for the RCA-based ALU
│   └── tb_alu_cla.v    # Testbench for the CLA-based ALU
├── docs/
│   └── SEC_ALU_.pdf    # Full project report (source doc)
└── README.md
```

## Note on the CLA module

The uploaded report includes the **testbenches** for the CLA-based ALU
(`alu_cla`, with an added `remainder` output) but the extracted text did not
contain the full `alu_cla` RTL source (Section 5.1 refers to it but the code
block wasn't recovered from the PDF). `tb/tb_alu_cla.v` is included as-is and
expects a module named `alu_cla` with ports `A, B, opcode, result, remainder,
valid, error` — add that module under `rtl/` (e.g. `rtl/alu_cla.v`) before
simulating it. Happy to draft that module for you if you'd like.

## Simulating (Icarus Verilog + GTKWave)

```bash
# RCA-based ALU
iverilog -o sim_rca rtl/alu_2bit.v tb/tb_alu.v
vvp sim_rca
gtkwave dump.vcd

# CLA-based ALU (once rtl/alu_cla.v is added)
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
