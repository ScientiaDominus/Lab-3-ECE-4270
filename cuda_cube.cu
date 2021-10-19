#include <stdio.h>
#include <stdlib.h>

__global__ void multAdd(float* d_out, float* d_in)
{
    int idx = threadidx.x;
    int f = d_in(idx);
    d_out(idx) = ((2*f) + 1);
}


int main(int argc, int** argv)
{
    int ARRAY_SIZE = 128;
    int ARRAY_MEM = ARRAY_SIZE*sizeof(float);

    float* h_in = malloc(ARRAY_MEM);
    float* h_out = malloc(ARRAY_MEM);

    for(int i = 0; i < ARRAY_SIZE; i++)
    {
        h_in(i) = float(i);
    }

    cudaMalloc(&d_in, ARRAY_MEM);
    cudaMalloc(&d_out, ARRAY_MEM);

    cudaMemCpy(h_in, d_in, ARRAY_SIZE, cudaMemCpyHostToDevice);
    
    multadd<<<1, 128>>> (d_in, d_out);
    
    cudaMemCpy(d_out, h_out, ARRAY_SIZE, cudaMemCpyDeviceToHost);

    for(int i = 0; i < ARRAY_SIZE; i++)
    {
        printf("%f\n", h_out(i));
    }
    
    cudaFree(d_in);
    cudaFree(d_out);

    free(h_in);
    free(h_out);

    return 0;
}