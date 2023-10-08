#include "ex2.h"
#include "math.h"

void v_add_naive(double *x, double *y, double *z)
{
#pragma omp parallel
    {
        for (int i = 0; i < ARRAY_SIZE; i++)
            z[i] = x[i] + y[i];
    }
}

// Adjacent Method
void v_add_optimized_adjacent(double *x, double *y, double *z)
{
    // TODO: Implement this function
    // Do NOT use the `for` directive here!
#pragma omp parallel
    {
        int thread_num = omp_get_num_threads();
        int t_id = omp_get_thread_num();
        for (int i = t_id; i < ARRAY_SIZE; i += thread_num)
        {
            /* code */
            z[i] = x[i] + y[i];
        }
    }
}

// Chunks Method
void v_add_optimized_chunks(double *x, double *y, double *z)
{
// TODO: Implement this function
// Do NOT use the `for` directive here!
#pragma omp parallel
    {
        int thread_num = omp_get_num_threads();
        int t_id = omp_get_thread_num();
        int chunk_size = ceil(ARRAY_SIZE / (double)thread_num);

        for (int i = t_id * chunk_size; i < (t_id + 1) * chunk_size && i < ARRAY_SIZE; i += 1)
        {
            /* code */
            z[i] = x[i] + y[i];
        }
    }
}
