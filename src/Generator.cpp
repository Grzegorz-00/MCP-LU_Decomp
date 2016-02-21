#include "Generator.h"

void Generator::generateEq(Matrix& A, Vector& vx, Vector& b)
{
	double** matrixPtr = A.getPtr();
	double* vectorXPtr = vx.getPtr();
	double* vectorBPtr = b.getPtr();

	int size = A.getSize();

	for(int x = 0;x<size;x++)
	{
		for(int y = 0;y<size;y++)
		{
			//from -50 to 50 step 0.1
			matrixPtr[x][y] = (rand()%10 );
		}

		vectorXPtr[x] = (rand()%10 );

	}
	Matrix::MatXVect(b,A,vx);
}
