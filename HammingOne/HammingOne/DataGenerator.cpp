#include "DataGenerator.h"

void GenerateData(std::string fileName, int vectorsCount, int vectorLength)
{
	srand(time(NULL));
	std::ofstream dataFile(fileName + ".txt");

	for (int i = 0; i < vectorsCount; i++)
	{
		for (int j = 0; j < vectorLength; j++)
		{
			dataFile << (rand() % 2);
		}
		dataFile << "\n";
	}

	dataFile.close();
}