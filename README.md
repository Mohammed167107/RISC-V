# Custom Low-Power RISC-V Processor with Edge AI Acceleration

This repository contains the complete hardware/software co-design of a custom **RISC-V processor**, optimized for low-power operation and integrated with an **Edge AI Accelerator**. This project serves as a graduation research project, demonstrating the full flow from ISA definition to ASIC synthesis.

## 🚀 Project Overview

The goal of this project is to design a functional RISC-V core capable of executing a subset of the RV32I Instruction Set Architecture (ISA), specifically tailored for embedded applications and AI-driven edge tasks.

### Key Features
* **ISA Support:** Implements **RV32I** (Base Integer) instruction set, including R-type, I-type, S-type, and U-type instructions.
* **Assembler Integration:** Supported by a custom **Python-based RISC-V Assembler** that converts assembly code into machine-executable hex files.
* **Edge AI Integration:** Features an integrated hardware accelerator designed to optimize vector operations common in neural network inference.
* **ASIC Ready:** The design is optimized for the **OpenROAD** flow and **Sky130** (130nm) process for future tape-out.
* **FPGA Prototyping:** Verified and tested on the **Intel Cyclone V (DE10-Standard)** platform.

---

## 🛠 Architectural Components

### 1. The Core (RV32I)
The core logic includes a single-cycle datapath (expandable to a pipeline) with:
* **Control Unit:** Decodes OpCodes and manages the internal muxes for data flow.
* **ALU:** Handles arithmetic/logic operations (ADD, SUB, AND, OR, XOR, SLT).
* **Register File:** 32 general-purpose registers (x0-x31).
* **Immediate Generator:** Extracts and sign-extends constants from instructions.

### 2. Edge AI Accelerator
Designed as a memory-mapped peripheral to the RISC-V core, allowing for:
* Hardware-accelerated MAC (Multiply-Accumulate) operations.
* Low-latency data processing for edge-level sensor fusion.

---

## 📂 Repository Structure

* `/rtl`: Verilog/SystemVerilog source files for the RISC-V Core and AI Accelerator.
* `/assembler`: Python script to generate machine code for testing.
* `/scripts`: Tcl scripts for OpenROAD and ASIC synthesis flow.
* `/tests`: Assembly test programs and Verilog testbenches.

---

## 💻 Technical Workflow

### 1. Assembly & Simulation
Write your RISC-V assembly, convert it via the Python assembler, and load the resulting `.hex` file into the instruction memory.

python3 assembler.py input.s -o program.hex

FPGA Implementation
The design is synthesized using Quartus Prime for the DE10-Standard board.

Frequency: 50 MHz.

Status Monitoring: Internal registers are mapped to the 7-segment displays for real-time debugging.

ASIC Synthesis (Sky130)
Using the OpenROAD flow, the RTL is converted into a physical layout:

Synthesis: Logic mapping.

Floorplanning: Power grid and macro placement.

Routing: Global and detail routing for timing closure.

Ongoing Development
Implementing full M-extension (Hardware Multiply/Divide).

Transitioning from single-cycle to 5-stage pipeline with hazard detection.

Finalizing GDSII for Sky130 tape-out.

Author: Mohammad Shobaki

Topic: Computer Engineering Research | RISC-V | ASIC | Edge AI
