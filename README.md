# FPGA Distributed Join

```markdown
# Partitioned Hash Join Implementation

This repository contains the SystemVerilog implementation of an partitioned hash join module, along with its testbench, related modules and python scripts for input generation and output verification. The report contains detailed explanations of all models and the result of our testing of this module.

## Top Level Module
- `Partitioned_Hash_Join.sv`

## Top Level Testbench
- `PHJ_tb.sv`

## Other Files to be Included
- `BRAM.sv`
- `murmur.sv`
- `murmur_8way.sv`
- `Gate.sv`
- `HashTable.sv`
- `DD2.sv`
- `DD4.sv`
- `DD4_2bit.sv`
- `DD8.sv`
- `DD8_3bit.sv`

```


### Running the Benchmark

Follow these steps to run the benchmark and verify the output:


### 1. Generate and Copy Benchmark Fies

Generate the input files for the simulation. There are 3 python scripts that generate input according to different distributions. When using the "zipf" distribution, the value of "z" can be changend in the script. (See report for details)


```bash
python3 benchmark_generator_"wanted_distribution".py
```

```bash
scp /"wanted input"/*_tuples* "user"@alveo-build-01.ethz.ch:/scratch/"user"
```



### 2. Run Simulation in Vivado

Open Vivado and run the simulation using the copied benchmark files.

### 3. Copy Output of Simulation

```bash
scp philipen@alveo-build-01.ethz.ch:/scratch/"user"/output_* /check_output
```

### 4. Verify Output

- Run the following command to verify the output:

```bash
python3 check_output.py
```

## Directory Structure

```
├── Partitioned_Hash_Join.sv
    ├──murmur_8way.sv
        ├──murmur.sv
    ├── HashTable.sv
        ├── BRAM.sv
    ├── DD8_3bit.sv
        ├── DD8.sv
        ├── DD4_2bit.sv
            ├── DD4.sv
                ├── DD2.sv
                    ├── Gate.sv
            ├── DD2.sv
                ├── Gate.sv
```

