
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>

int main()
{
	int l, n, x;
	printf("Enter set of vectors count: ");
	scanf("%d", &n);
	printf("Enter vector length: ");
	scanf("%d", &l);
	printf("Find the number of vectors pairs with Hamming one distance by \n 1.CPU \n 2.GPU \n:");
	scanf("%d", &x);
	if (x == 1)
	{
		printf("Sory no CPU version. \n");
	}
	if (x == 2)
	{
		printf("Sory no GPU version. \n");
	}

    return 0;
}

