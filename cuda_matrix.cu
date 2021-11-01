#include <stdio.h>
#include <stdlib.h>

__global__ void MatrixAdd(float* d_out, float* d_in1, float* d_in2, int M, int N)
{
    int idx = blockDim.x * blockIdx.x + threadIdx.x;
    float f = d_in1[idx];
    float g = d_in2[idx];
    if(blockIdx.x < M && threadIdx.x < N)
    {
        d_out[idx] = f + g;
    }
}

int main(int argc, char* argv[])
{
    FILE *fp;
    if(argc < 2)
    {
        int i =0;
        while(i != 10)
        {
            printf("WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING\n");
            i++;
        }
        printf("ERROR: NO INPUT FILE SELECTED! USE %s <INPUT FILE> \n\n", argv[0]);
        exit(1);
    }
    char* filename = (char*)malloc(strlen(argv[1])*sizeof(char));
    strcpy(filename, argv[1]);
    fp = fopen(filename, "r");
    if(fp == NULL)
    {
        int i = 0;
        while(i != 10)
        {
            printf("WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING\n");
            i++;
        }
        printf("ERROR: FILE COULD NOT BE READ. CANT EVEN TYPE A FILE NAME EH? NERD\n");
        free(filename);
        fclose(fp);
        exit(1);
    }
    int M, N;
    M = N = 0;
    fscanf(fp, "%d %d", &M, &N);
    int MATRIXMEM = (M*N) * sizeof(float);
    float *h_in1;
    h_in1 = (float*)malloc(MATRIXMEM);
    for(int x = 0; x < M; x++)
    {
        for(int y = 0; y < N; y++)
        {
            h_in1[x*N + y] = 0;
        }
    }
    for(int x = 0; x < M; x++)
    {
        for(int y = 0; y < N; y++)
        {
            fscanf(fp, "%f", &h_in1[x*N + y]);
        }
    }
    fscanf(fp, "%d %d", &M, &N);
    float* h_in2;
    h_in2 = (float*)malloc(MATRIXMEM);
    for(int x = 0; x < M; x++)
    {
        for(int y = 0; y < N; y++)
        {
            h_in2[x*N + y] = 0;
        }
    }
    for(int x = 0; x < M; x++)
    {
        for(int y = 0; y < N; y++)
        {
            fscanf(fp, "%f", &h_in2[x*N + y]);
        }
    }
    float* h_out = (float*)malloc(MATRIXMEM);
    float *d_out, *d_in1, *d_in2;
    cudaMalloc(&d_in1, MATRIXMEM);
    cudaMalloc(&d_in2, MATRIXMEM);
    cudaMalloc(&d_out, MATRIXMEM);

    cudaMemcpy(d_in1, h_in1, MATRIXMEM, cudaMemcpyHostToDevice);
    cudaMemcpy(d_in2, h_in2, MATRIXMEM, cudaMemcpyHostToDevice);

    MatrixAdd<<<M, N>>>(d_out, d_in1, d_in2, M, N);


    cudaMemcpy(h_out, d_out, MATRIXMEM, cudaMemcpyDeviceToHost);

    for(int x = 0; x < M; x++)
    {
        for(int y = 0; y < N; y++)
        {
            printf("%12f ", h_out[x*N + y]);
        }
        printf("\n");
    }

    cudaFree(d_in1);
    cudaFree(d_in2);
    cudaFree(d_out);
    free(h_in1);
    free(h_in2);
    free(h_out);
    fclose(fp);
    exit(0);
}