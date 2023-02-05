#!/bin/bash

#SBATCH -J pi-mt               # Job Name
#SBATCH -A GOV111082           # Account
#SBATCH -p ct2k                # Partition
#SBATCH -o mt_out_%j.log       # Redirect `stdout` to File
#SBATCH -e mt_err_%j.log       # Redirect `stderr` to File

#SBATCH -n 1000                # `--ntasks`, number of tasks / MPI ranks / processes                                 $SLURM_NTASKS
#
# #SBATCH -c 1                 # `--cpus-per-task`, number of cores / threads **per** tasks / MPI ranks / processes. $SRUN_CPUS_PER_TASK
# #SBATCH -N 18                # `--nodes`, number of **minimium** nodes!!                                           $SLURM_NNODES
# #SBATCH --ntasks-per-node=56 # number of **minimium** tasks / MPI ranks / processes per nodes!!                    $SLURM_NTASKS_PER_NODE
#
# $SLURM_NTASKS <= $SLURM_NNODES * $SLURM_NTASKS_PER_NODE
# $SLURM_NTASKS_PER_NODE * $SRUN_CPUS_PER_TASK <= The number of CPU cores per node (56 for Taiwania 3)

ml purge

echo "Build the binaries!!"
make all CC=mpicc
cd build

echo "Calculat $\pi$ by Monte Carlo method!!"
time srun ./pi_monte_carlo
