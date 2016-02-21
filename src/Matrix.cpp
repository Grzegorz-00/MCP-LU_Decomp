#include "Matrix.h"

Matrix::Matrix(int size)
{
	_size = size;
	_data = new double*[size];
	for(int i = 0;i<size;i++)
	{
		_data[i] = new double[size];
		for(int j = 0;j<_size;j++)
		{
			_data[i][j] = 0;
		}
	}
}
Matrix::~Matrix()
{
	for(int i = 0;i<_size;i++)
	{
		delete[] _data[i];
	}
	delete[] _data;
}
double** Matrix::getPtr()
{
	return _data;
}
double Matrix::getVal(int x, int y)
{
	if(x >= 0 && x < _size && y >= 0 && y < _size)
	{
		return _data[x][y];
	}
	else
	{
		return 0;
	}
}
void Matrix::setVal(int x, int y, double val)
{
	if(x >= 0 && x < _size && y >= 0 && y < _size)
	{
		_data[x][y] = val;
	}
}

int Matrix::getSize()
{
	return _size;
}

void Matrix::print()
{
	for(int y = 0;y<_size;y++)
	{
		for(int x = 0;x<_size;x++)
		{
			printf("%6.3lf ",_data[x][y]);
		}
		std::cout << std::endl;
	}
	std::cout << std::endl;
}

void Matrix::MatXVect(Vector& res, Matrix& m, Vector& v)
{
	int size = m.getSize();
	double* resPtr = res.getPtr();
	double** mPtr = m.getPtr();
	double* vPtr = v.getPtr();

	for(int y = 0;y<size;y++)
	{
		double sum = 0;
		for(int x = 0;x<size;x++)
		{
			sum+= mPtr[x][y]*vPtr[x];
		}
		resPtr[y] = sum;
	}
}
