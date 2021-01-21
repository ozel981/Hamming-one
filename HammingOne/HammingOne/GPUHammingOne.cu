
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <thrust/reduce.h>
#include <thrust/execution_policy.h>
#include <stdio.h>

#define INTERVAL_LENGTH 5

#include "GPUHammingOne.cuh"

#define gpuErrchk(ans) { gpuAssert((ans), __FILE__, __LINE__); }
inline void gpuAssert(cudaError_t code, const char *file, int line, bool abort = true)
{
	if (code != cudaSuccess)
	{
		fprintf(stderr, "GPUassert: %s %s %d\n", cudaGetErrorString(code), file, line);
		if (abort) exit(code);
	}
}

__global__ void CalculateHammingOne(int* val, bool* set, int from, int n, int l, int radius)
{
	int index = (blockIdx.x * 1000) + threadIdx.x + (10000 * radius);
	if (index < n)
	{
		int differencesCount;
		for (int i = from > index + 1 ? from : index + 1; i < n; i++)
		{
			differencesCount = 0;
			for (int j = 0; j < l; j++)
			{
				if (set[index * l + j] != set[i * l + j]) differencesCount++;
				if (differencesCount > 1) break;
			}
			if (differencesCount == 1)
			{
				atomicAdd(val, 1);
				printf("Hamming one distance: [%d]x[%d]\n ", index, i);
			}
		}
	}
}


extern "C" int GPUHammingOneCount(Data* h_data)
{
	//Data* d_data;
	int n = h_data->count;
	int l = h_data->length;
	bool* h_set = new bool[l*n];
	for (int i = 0; i < n; i++)
	{
		for (int j = 0; j < l; j++)
		{
			h_set[i * l + j] = h_data->set[i][j];
		}
	}
	bool* d_set;
	cudaMalloc((void**)&d_set, l * n * sizeof(bool));
	cudaMemcpy(d_set, h_set, l * n * sizeof(bool), cudaMemcpyHostToDevice);
	int h_val = 0;
	int* d_val;
	cudaMalloc(&d_val, sizeof(int));
	cudaMemcpy(d_val, &h_val, sizeof(int), cudaMemcpyHostToDevice);
	for (int radius = 0; radius <= n / 10000; radius++)
	{
		for (int i = 0; i < INTERVAL_LENGTH; i++)
		{
			int from = i * (n / INTERVAL_LENGTH);
			int to = (i + 1)*(n / INTERVAL_LENGTH);
			CalculateHammingOne << <10, 1000 >> > (d_val, d_set, from, to, l, radius);
		}
	}
	
	cudaMemcpy(&h_val, d_val, sizeof(int), cudaMemcpyDeviceToHost);


	gpuErrchk(cudaPeekAtLastError());
	

	cudaFree(d_set);

	return h_val;
}
