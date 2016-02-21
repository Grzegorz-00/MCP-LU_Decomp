#include "Vector.h"

Vector::Vector(int size)
{
	_size = size;
	_data = new double[_size];
	for(int i = 0;i<_size;i++)
	{
		_data[i] = 0;
	}
}
Vector::~Vector()
{
	delete[] _data;
}
double* Vector::getPtr()
{
	return _data;
}
double Vector::getVal(int x)
{
	if(x >= 0 && x < _size)
	{
		return _data[x];
	}
	else
	{
		return 0;
	}
}
void Vector::setVal(int x, double val)
{
	if(x >= 0 && x < _size)
	{
		_data[x] = val;
	}
}
int Vector::getSize()
{
	return _size;
}

void Vector::print()
{
	for(int x = 0;x<_size;x++)
	{
		std::cout << _data[x] << " ";
	}
	std::cout << std::endl;
	std::cout << std::endl;
}
