#include "CPUHammingOne.h"
#include <stdio.h>
#include <iostream>
#include <time.h>
#include <fstream>

using namespace std;

bool IsHammingOneDistance(bool* v1, bool* v2, int length);

int CPUHammingOneCount(Data* data)
{
	int count = 0;
	std::ofstream outputFile("CPUoutput.txt");
	for (int i = 0; i < data->count; i++)
	{
		for (int j = i + 1; j < data->count; j++)
		{
			if (IsHammingOneDistance(data->set[i], data->set[j], data->length))
			{
				count++;
				outputFile << "Hamming one distance rows nr : [" << i << "]x[" << j << "]\n";
			}
		}
	}
	outputFile.close();
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