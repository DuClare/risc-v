# Why this project

This project is to upgrade my SystemVerilog skill as well as understanding ISA, CPU, and hardware architectures better. 
This is a first published and documented project.

This also marks the starting point of a series of projects, all focused on deepening my technical skills as an FPGA engineer.

# RV32I Single-Cycle Processor

The project goal is to write a single-cycle RISC-V (RV32I) processor in SystemVerilog.
Later, the goal will be to add more ISA support, as well as targeting my personal [QMTech Wukong Board](https://github.com/ChinaQMTECH/QM_XC7A100T_WUKONG_BOARD/tree/master/V3) (Artix-7 XC7A100T) as well as my [QMTech ZYJZGW Zynq-7000 board](https://github.com/ChinaQMTECH/ZYJZGW_ZYNQ_STARTER_KIT_V2) (Zynq XC7Z010).

## Status

All RV32I base integer instructions are supported (arithmetic, logical, shifts, branches, jumps, loads, stores) except byte/halfword memory access.

## Project Structure

```
rtl/pkg/         Package with shared types and enums
rtl/core/        CPU modules (ALU, register file, decoder, control, memories, ...)
rtl/top/         Top-level integration
verif/           Testbenches
sw/              Test programs (assembly + hex)
```

## Running a simulation

Running a simulation can be done with the tools of your choice, however an example is given below. 

You can use the [oss-cad-suite](https://github.com/YosysHQ/oss-cad-suite-build) (iverilog + vvp).

In the project root:

```bash
# Compile
iverilog -g2012 -o sim/tb_risc_v.vvp \
  rtl/pkg/pkg.sv rtl/core/*.sv rtl/top/risc_v.sv verif/tb_risc_v.sv

# Run
vvp sim/tb_risc_v.vvp
```

Expected output for the included test program (`sw/program.hex`):
```
x1 = 10
x2 = 5
x3 = 5
x4 = 1
x5 = 10
```

## Verification

The verification goal would be to pass all tests from the official [riscv-tests](https://github.com/riscv-software-src/riscv-tests) suite (rv32ui).
