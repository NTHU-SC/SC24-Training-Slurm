#!/bin/bash

#SBATCH -J pi-mt-Intel-OMPI    # Job Name
#SBATCH -A GOV111082           # Account
#SBATCH -p ct2k                # Partition
#SBATCH -o mt_iompi_%j_out.log # Redirect `stdout` to File
#SBATCH -e mt_iompi_%j_err.log # Redirect `stderr` to File

#SBATCH -n 1000                # `--ntasks`, number of tasks / MPI ranks / processes                       $SLURM_NTASKS
#
# #SBATCH -c 1                 # `--cpus-per-task`, number of cores / threads **per** tasks / MPI ranks / processes. $SRUN_CPUS_PER_TASK
# #SBATCH -N 18                # `--nodes`, number of **minimium** nodes!!                               $SLURM_NNODES
# #SBATCH --ntasks-per-node=56 # number of **minimium** tasks / MPI ranks / processes per nodes!!          $SLURM_NTASKS_PER_NODE
#
# $SLURM_NTASKS <= $SLURM_NNODES * $SLURM_NTASKS_PER_NODE
# $SLURM_NTASKS_PER_NODE * $SRUN_CPUS_PER_TASK <= The number of CPU cores per node (56 for Taiwania 3)

ml purge
ml compiler/intel/2021 OpenMPI/4.1.0

echo "Build the binaries!!"
BUILD=build/icc_ompi
LC_ALL=C make all # It seems that for `icc` and Intel MPI, we have to set locale properly.
cd $BUILD

echo "Calculat $\pi$ by Monte Carlo method!!"
for n in 1000000 1000000000 1000000000000
do
    printf "\tN=$n\n"
    time srun ./pi_monte_carlo $n
done
