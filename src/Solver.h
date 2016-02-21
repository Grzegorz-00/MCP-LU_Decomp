#ifndef SOLVER_H_
#define SOLVER_H_

#include "Matrix.h"
#include "Vector.h"

class Solver
{
public:
	static int LUSolveCPU(Matrix& A, Vector& x, Vector& b);
	static int LUSolveCUDA(Matrix& A, Vector& x, Vector& b);
};



#endif
