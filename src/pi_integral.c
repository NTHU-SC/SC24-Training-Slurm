/**                  _ _              _____ ___
 *  _ __   _____   _(_) | ____      _|___ // _ \
 * | '_ \ / _ \ \ / / | |/ /\ \ /\ / / |_ \ (_) |
 * | | | |  __/\ V /| |   <  \ V  V / ___) \__, |
 * |_| |_|\___| \_/ |_|_|\_\  \_/\_/ |____/  /_/
 **/

#include <assert.h>
#include <errno.h>
#include <float.h>
#include <inttypes.h>
#include <limits.h>
#include <math.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

#include <mpi.h>

#pragma message("GL; HF!")

#ifndef N
#define N 1000000000 // 1e9
#endif               // N

#ifdef M_PIl
#define PI M_PIl
#else
#define PI 3.141592653589793238462643383279502884L
#endif // M_PIl

typedef unsigned long long ull;

int main(int argc, char *argv[])
{
    int rank, size;

    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    MPI_Barrier(MPI_COMM_WORLD);
    double tik = MPI_Wtime();

    const ull n = argc > 1 ? strtoull(1[argv], NULL, 10) : N;

    long double cnt = 0;
    for (ull i = rank; i < n; i += size)
    {
        long double x = 1.l * i / n;
        cnt += 1.l / (1.l + x * x);
    }

    long double sum = 0;
    MPI_Reduce(&cnt, &sum, 1, MPI_LONG_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);

    MPI_Barrier(MPI_COMM_WORLD);
    double tok = MPI_Wtime();

    if (!rank) // rank == 0
    {
        long double pi = 4.l * sum / n;
        printf("pi\t= %.9Lf\nAbs err\t= %.9Lf\n", pi, fabsl(pi - PI));
        fprintf(stderr, "Wall time: %f\n", tok - tik);
    }

    MPI_Finalize();
    return 0;
}
