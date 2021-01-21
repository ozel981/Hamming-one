
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <thrust/reduce.h>
#include <thrust/execution_policy.h>


#include "GPUHammingOne.cuh"

__global__ void CalculateHammingOne(int* count, bool* set, int n, int l)
{
	int index = (blockIdx.x * 1024) + threadIdx.x;
	if (index < (n + 1) / 2)
	{
		count[index] = 0;
		for (int i = index + 1; i < n; i++)
		{
			int differencesCount = 0;
			for (int j = 0; j < l; j++)
			{
				if (set[index * l + j] != set[i * l + j]) differencesCount++;
				if (differencesCount > 1) break;
			}
			if (differencesCount == 1)
			{
				count[index] += 1;
				printf("Hamming one distance: [%d]x[%d]\n", index, i);
			}
		}	
		if (n - 1 - index != index)
		{
			index = n - 1 - index;
			count[index] = 0;
			for (int i = index + 1; i < n; i++)
			{
				int differencesCount = 0;
				for (int j = 0; j < l; j++)
				{
					if (set[index * l + j] != set[i * l + j]) differencesCount++;
					if (differencesCount > 1) break;
				}
				if (differencesCount == 1)
				{
					count[index] += 1;
					printf("Hamming one distance: [%d]x[%d]\n", index, i);
				}
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
	int* h_count = new int[n];
	int* d_count;
	cudaMalloc((void**)&d_count, n * sizeof(int));
	int ndiv2 = n / 2;
	CalculateHammingOne << <1 + (ndiv2 / 1024), 1024 >> > (d_count, d_set, n, l);
	cudaMemcpy(h_count, d_count, n * sizeof(int), cudaMemcpyDeviceToHost);

	int count = 0;

	cudaFree(d_count);
	cudaFree(d_set);
	return thrust::reduce(thrust::host, h_count, h_count + n, 0);
}
