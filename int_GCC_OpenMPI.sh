#!/bin/bash

#SBATCH -J pi-int-GCC-OMPI      # Job Name
#SBATCH -A GOV111082           # Account
#SBATCH -p ct2k                # Partition
#SBATCH -o int_ompi_%j_out.log # Redirect `stdout` to File
#SBATCH -e int_ompi_%j_err.log # Redirect `stderr` to File

#SBATCH -n 1000                # `--ntasks`, number of tasks / MPI ranks / processes

ml purge
ml compiler/gcc/10.2.0 OpenMPI

echo "Build the binaries!!"
BUILD=build/gcc_ompi
make all
cd $BUILD

export UCX_NET_DEVICES=all # The UCX config of the module is incorrect!! We have to fix it manually.
ulimit -s 10240            # Suppress annoying warnings

echo "Calculat $\pi$ by integral!!"
for n in 1000000 1000000000 1000000000000
do
    printf "\tN=$n\n"
    time srun ./pi_integral $n
done
