
#include "cuda_runtime.h"
#include "device_launch_parameters.h"


#include "GPUHammingOne.cuh"

/*__device__ bool IsHammingOne(std::string s1, std::string s2)
{
	int count = 0;
	for (int i = 0; i < s1.length(); i++)
	{
		if (s1[i] != s2[i]) count++;
		if (count > 1) return false;
	}
	return count == 1;
}
*/
__global__ void CalculateHammingOne(int* count, Data* d_data)
{
	int index = (blockIdx.x * 1024) + threadIdx.x;

	if (index < d_data->count)
	{
		count[index] = d_data->set[index][1];
		/*for (int i = index + 1; i < d_data->count; i++)
		{
			//if (IsHammingOne(set[index], set[i])) counts[index]++;
			int differencesCount = 0;
			for (int j = 0; j < d_data->length; j++)
			{
				if (d_data->set[index][j] != d_data->set[i][j]) differencesCount++;
				if (differencesCount > 1) break;
			}
			if (differencesCount == 1) count[index]+=1;
		}*/
	}
}


extern "C" int GPUHammingOneCount(Data* h_data)
{
	Data* d_data;
	int n = h_data->count;
	int* d_count;
	int* h_count = new int[n];
	cudaMalloc((void**)&d_data, sizeof(Data));
	cudaMalloc((void**)&d_count, n * sizeof(int));
	cudaMemcpy(d_data, h_data, sizeof(Data), cudaMemcpyHostToDevice);
	CalculateHammingOne << <1 + (n / 1024), 1024 >> > (d_count, d_data);
	cudaMemcpy(h_count, d_count, n * sizeof(int), cudaMemcpyDeviceToHost);

	int count = 0;

	for (int i = 0; i < n; i++)
	{
		count += h_count[i];
	}

	cudaFree(d_count);
	cudaFree(d_data);
	return count;
}
