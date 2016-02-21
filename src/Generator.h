#ifndef GENERATOR_H_
#define GENERATOR_H_

#include <cstdlib>
#include "Matrix.h"
#include "Vector.h"

class Generator
{
public:
	static void generateEq(Matrix& A, Vector& x, Vector& b);
};



#endif
