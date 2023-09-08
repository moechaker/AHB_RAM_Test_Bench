# AHB_RAM_Test_Bench

This repository contains a comprehensive SystemVerilog test bench and associated files developed to systematically validate the functionality and data integrity of an AHB (Advanced High-Performance Bus) memory. The test bench employs advanced verification methodologies, including constrained randomization, to generate a wide range of test scenarios. These scenarios encompass diverse AHB transactions, addressing modes, data transfers to ensure the thorough validation of the AHB memory's behavior.

## Introduction

The AHB Memory Verification Test Bench project is dedicated to guaranteeing the reliability and correctness of an AHB memory module through rigorous testing. The test bench generates a multitude of sequences involving AHB transactions, addressing various transaction types (read, write, etc.), burst sizes, address ranges, and data patterns. This comprehensive approach captures potential issues such as data corruption, response errors, and protocol infringements.

## Important Notes
- PLEASE NOTE THAT I HAVE NOT WRITTEN THE DESIGN, I HAVE ONLY VERIFIED IT
- design.sv IS NOT WRITTEN BY ME
- EVERYTHING ELSE IS DONE BY ME
- sorry for shouting that out lol, I just wanted it to be seen

## Usage

To run the design verification test bench, follow these steps:

1. Visit this link: https://www.edaplayground.com/x/8kA3
2. Top right, hit login and create an account
3. Eda Playground might open a new playground for you, so go ahead and click on my link again to open my playground
4. On the left, click on "Open EPWave after run" under Tools & Simulators if you wish to analyze the waveforms
5. hit Run

Throughout the simulation process, the test bench orchestrates AHB transactions while interacting with the memory module. Responses from the memory module are exhaustively monitored and cross-checked against expected outcomes, enabling the rapid identification of any irregularities or discrepancies.
