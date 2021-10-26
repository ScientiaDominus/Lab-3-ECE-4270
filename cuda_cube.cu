#include <stdio.h>
#include <stdlib.h>

__global__ void multAdd(float *d_in, float *d_out)
{
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    int f = d_in[idx];
    d_out[idx] = ((2*f) + 1);
}


int main(int argc, char** argv)
{
    int ARRAY_SIZE = 128;
    int ARRAY_MEM = ARRAY_SIZE*sizeof(float);

    float* h_in = (float*)malloc(ARRAY_MEM);
    float* h_out = (float*)malloc(ARRAY_MEM);
    float *d_out, *d_in;

    for(int i = 0; i < ARRAY_SIZE; i++)
    {
        h_in[i] = i;
    }

    cudaMalloc(&d_in, ARRAY_MEM);
    cudaMalloc(&d_out, ARRAY_MEM);

    cudaMemcpy(d_in, h_in, ARRAY_MEM, cudaMemcpyHostToDevice);
    
    multAdd<<<1, 128>>>(d_in, d_out);
    
    cudaMemcpy(h_out, d_out, ARRAY_MEM, cudaMemcpyDeviceToHost);

    for(int i = 0; i < ARRAY_SIZE; i += 4)
    {
        printf("%10f %10f %10f %10f\n", h_out[i], h_out[i+1], h_out[i+2], h_out[i+3]);
    }
    
    cudaFree(d_in);
    cudaFree(d_out);

    free(h_in);
    free(h_out);

    return 0;
}