
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>

#include "DataGenerator.h";

int main()
{
	int l, n, x;
	printf("Find the number of vectors pairs with Hamming one distance by \n 1.CPU \n 2.GPU \n 3.Generate test data\n:");
	scanf("%d", &x);
	if (x == 1)
	{
		printf("Sory no CPU version. \n");
	}
	if (x == 2)
	{
		printf("Sory no GPU version. \n");
	}
	if (x == 3)
	{
		printf("Enter set of vectors count: ");
		scanf("%d", &n);
		printf("Enter vector length: ");
		scanf("%d", &l);
		GenerateData("test2", n, l);
	}

    return 0;
}

