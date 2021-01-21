
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>

#include "DataGenerator.h"
#include "CPUHammingOne.h"
#include "GPUHammingOne.cuh"
#include "ReadData.h"

extern "C" int GPUHammingOneCount(Data* data);

int main()
{
	int l, n, x;
	printf("Find the number of vectors pairs with Hamming one distance by \n 1.CPU \n 2.GPU \n 3.Generate test data\n:");
	scanf("%d", &x);
	if (x == 1)
	{
		int count = CPUHammingOneCount(&ReadData("test3"));
		printf("Hamming one distance count: %d \n", count);
	}
	if (x == 2)
	{
		int count = GPUHammingOneCount(&ReadData("test3"));
		std::cout << count << std::endl;
		printf("Hamming one distance count: %d \n", count);
	}
	if (x == 3)
	{
		printf("Enter set of vectors count: ");
		scanf("%d", &n);
		printf("Enter vector length: ");
		scanf("%d", &l);
		GenerateData("test3", n, l);
	}

    return 0;
}

