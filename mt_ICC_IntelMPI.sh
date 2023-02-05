#!/bin/bash

#SBATCH -J pi-mt-IntelMPI      # Job Name
#SBATCH -A GOV111082           # Account
#SBATCH -p ct2k                # Partition
#SBATCH -o mt_impi_%j_out.log  # Redirect `stdout` to File
#SBATCH -e mt_impi_%j_err.log  # Redirect `stderr` to File

#SBATCH -n 1000                # `--ntasks`, number of tasks / MPI ranks / processes                       $SLURM_NTASKS
#
# #SBATCH -c 1                 # `--cpus-per-task`, number of cores / threads **per** tasks / MPI ranks / processes. $SRUN_CPUS_PER_TASK
# #SBATCH -N 18                # `--nodes`, number of **minimium** nodes!!                               $SLURM_NNODES
# #SBATCH --ntasks-per-node=56 # number of **minimium** tasks / MPI ranks / processes per nodes!!          $SLURM_NTASKS_PER_NODE
#
# $SLURM_NTASKS <= $SLURM_NNODES * $SLURM_NTASKS_PER_NODE
# $SLURM_NTASKS_PER_NODE * $SRUN_CPUS_PER_TASK <= The number of CPU cores per node (56 for Taiwania 3)

ml purge
ml compiler/intel/2022 IntelMPI

echo "Build the binaries!!"
BUILD=build/icc_impi
make all CC=$MPICC
cd $BUILD

export UCX_NET_DEVICES=all # The UCX config of the module is incorrect!! We have to fix it manually.

echo "Calculat $\pi$ by Monte Carlo method!!"
for n in 1000000 1000000000 1000000000000
do
    printf "\tN=$n\n"
    time mpirun ./pi_monte_carlo $n
    # time mpiexec.hydra -bootstrap slurm ./pi_monte_carlo $n
done
