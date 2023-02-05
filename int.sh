#!/bin/bash

#SBATCH -J pi-int              # Job Name
#SBATCH -A GOV111082           # Account
#SBATCH -p ct2k                # Partition
#SBATCH -o int_out_%j.log      # Redirect `stdout` to File
#SBATCH -e int_err_%j.log      # Redirect `stderr` to File

#SBATCH -n 1000                # `--ntasks`, number of tasks / MPI ranks / processes

ml purge

echo "Build the binaries!!"
make all CC=mpicc
cd build

echo "Calculat $\pi$ by integral!!"
time srun ./pi_integral
