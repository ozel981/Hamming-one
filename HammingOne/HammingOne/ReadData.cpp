#include "ReadData.h"


using namespace std;

Data ReadData(string fileName)
{
	Data data = Data();

	string vector;

	ifstream dataFile(fileName + ".txt");

	int n = std::count(std::istreambuf_iterator<char>(dataFile),
		std::istreambuf_iterator<char>(), '\n');

	data.count = n;

	bool** set = new bool*[n];

	int iterator = 0;

	dataFile.seekg(0);

	while (getline(dataFile, vector))
	{
		int length = vector.length();
		set[iterator] = new bool[length];
		for (int i = 0; i < length; i++)
		{
			set[iterator][i] = vector[i] == '1';
		}
		data.length = length;
		iterator++;
	}

	dataFile.close();

	data.set = set;

	return data;
}