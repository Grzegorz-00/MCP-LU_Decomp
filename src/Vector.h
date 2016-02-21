#ifndef VECTOR_H_
#define VECTOR_H_

#include <iostream>

class Vector
{
private:
	int _size;
	double* _data;
public:
	Vector(int size);
	~Vector();
	double* getPtr();
	double getVal(int x);
	void setVal(int x, double val);
	int getSize();
	void print();
};



#endif
