#ifndef MATRIX_H_
#define MATRIX_H_

#include <iostream>
#include <cstdio>

#include "Vector.h"


class Matrix
{
private:
	int _size;
	double** _data;
public:
	Matrix(int size);
	~Matrix();
	double** getPtr();
	double getVal(int x, int y);
	void setVal(int x, int y, double val);
	int getSize();
	static void MatXVect(Vector& res, Matrix& m, Vector& v);
	void print();
};





#endif
