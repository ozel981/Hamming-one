#include "DataGenerator.h"

void GenerateData(std::string fileName, int vectorsCount, int vectorLength)
{
	srand(time(NULL));
	std::ofstream dataFile(fileName + ".txt");
	short** table = new short*[vectorsCount];

	for (int i = 0; i < vectorsCount; i++)
	{
		table[i] = new short[vectorLength];
		if (i % 2 == 0)
		{
			int index = rand() % 1000;
			for (int j = 0; j < vectorLength; j++)
			{
				if (j != index)
				{
					table[i][j] = table[i/2][j];
					dataFile << table[i][j];
				}
				else
				{
					table[i][j] = table[i / 2][j] == 1 ? 0 : 1;
					dataFile << table[i][j];
				}
			}
			dataFile << "\n";
		}
		else
		{ 
			for (int j = 0; j < vectorLength; j++)
			{
				table[i][j] = (rand() % 2);
				dataFile << table[i][j];
			}
			dataFile << "\n";
		}
	}

	dataFile.close();
}