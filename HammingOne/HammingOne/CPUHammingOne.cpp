#include "CPUHammingOne.h"

using namespace std;

int HammingDistance(string vector1, string vector2);

int CPUHammingOneCount(string fileName)
{
	string vector;

	ifstream dataFile(fileName + ".txt");

	int n = std::count(std::istreambuf_iterator<char>(dataFile),
		std::istreambuf_iterator<char>(), '\n');

	string* set = new string[n];

	int iterator = 0;

	dataFile.seekg(0);
	
	while (getline(dataFile, vector)) 
	{		
		set[iterator++] = vector;
	}

	int count = 0;

	for (int i = 0; i < n; i++)
	{
		for (int j = i + 1; j < n; j++)
		{
			if (HammingDistance(set[i], set[j]) == 1)
			{
				count++;
			}
		}
	}

	dataFile.close();

	return count;
}

int HammingDistance(string vector1, string vector2)
{
	int distance = 0;
	for (int i = 0; i < vector1.length(); i++)
	{
		if (vector1[i] != vector2[i])
		{
			distance++;
		}
	}
	return distance;
}