#include <stdio.h>
#include <stdlib.h>

__global__ void MatrixAdd(float** d_out, float** d_in1, float** d_in2)
{
    int idx = threadIdx.x;
    int f = d_in1[idx];
    int g = d_in2[idx];
    d_out[idx] = f + g;
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
    int MATRIX_SIZE = 0;
    fscanf(fp, "%f", &MATRIX_SIZE);
    int MATRIXMEM = (MATRIX_SIZE*MATRIX_SIZE) * sizeof(float);
    float **h_in1;
    h_in1 = (float**)malloc(MATRIXMEM);
    for(int x = 0; x < MATRIX_SIZE; x++)
    {
        for(int y = 0; y < MATRIX_SIZE; y++)
        {
            h_in1[x][y] = 0;
        }
    }
    for(int x = 0; x < MATRIX_SIZE; x++)
    {
        for(int y = 0; y < MATRIX_SIZE; y++)
        {
            fscanf(fp, "%d", &h_in1[x][y]);
        }
    }
    fscanf(fp, "%f", &MATRIX_SIZE);
    float** h_in2;
    h_in2 = (float**)malloc(MATRIXMEM);
    for(int x = 0; x < MATRIX_SIZE; x++)
    {
        for(int y = 0; y < MATRIX_SIZE; y++)
        {
            h_in2[x][y] = 0;
        }
    }
    for(int x = 0; x < MATRIX_SIZE; x++)
    {
        for(int y = 0; y < MATRIX_SIZE; y++)
        {
            fscanf(fp, "%d", &h_in2[x][y]);
        }
    }
    float** h_out = (float*)malloc(MATRIXMEM);
    float** d_out, d_in1, d_in2;
    cudaMalloc(&d_in1, MATRIXMEM);
    cudaMalloc(&d_in2, MATRIXMEM);
    cudaMalloc(&d_out, MATRIXMEM);

    cudaMemcpy(d_in1, h_in1, MATRIXMEM, cudaMemcpyHostToDevice);
    cudaMemcpy(d_in2, h_in2, MATRIXMEM, cudaMemcpyHostToDevice);

    MatrixAdd<<<1, 10>>>(d_out, d_in1, d_in2);
    MatrixAdd<<<11, 20>>>(d_out, d_in1, d_in2);
    MatrixAdd<<<21, 30>>>(d_out, d_in1, d_in2);
    MatrixAdd<<<31, 40>>>(d_out, d_in1, d_in2);
    MatrixAdd<<<41, 50>>>(d_out, d_in1, d_in2);
    MatrixAdd<<<51, 60>>>(d_out, d_in1, d_in2);
    MatrixAdd<<<61, 70>>>(d_out, d_in1, d_in2);
    MatrixAdd<<<71, 80>>>(d_out, d_in1, d_in2);
    MatrixAdd<<<81, 90>>>(d_out, d_in1, d_in2);
    MatrixAdd<<<91, 100>>>(d_out, d_in1, d_in2);

    cudaMemcpy(h_out, d_out, MATRIXMEM, cudaMemcpyDeviceToHost);

    for(int x = 0; x < MATRIX_SIZE; x++)
    {
        for(int y = 0; y < MATRIX_SIZE; y++)
        {
            printf("%5f", h_out[x][y]);
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