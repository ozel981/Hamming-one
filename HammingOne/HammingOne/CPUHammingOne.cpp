#include "CPUHammingOne.h"
#include <stdio.h>

using namespace std;

bool IsHammingOneDistance(bool* v1, bool* v2, int length);

int CPUHammingOneCount(Data* data)
{
	int count = 0;
	for (int i = 0; i < data->count; i++)
	{
		for (int j = i + 1; j < data->count; j++)
		{
			if (IsHammingOneDistance(data->set[i], data->set[j], data->length))
			{
				count++;
				printf("Hamming one distance: [%d]x[%d]\n", i, j);
			}
		}
	}
	return count;
}

bool IsHammingOneDistance(bool* v1, bool* v2, int length)
{
	int distance = 0;
	for (int i = 0; i < length; i++)
	{
		if (v1[i] != v2[i])
		{
			distance++;
		}
		if (distance > 1) break;		
	}
	return distance == 1;
}