#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

#include "Matrix.h"
#include "Vector.h"
#include "Generator.h"
#include "Solver.h"
#include <ctime>
#include <cmath>
#include <iostream>
#include <fstream>

int main(int argc, char **argv)
{

	std::ofstream file;
	file.open("timeCompare.txt");


	srand(time(NULL));
	for(int i = 100;i<2000;i+=100)
	{

		Matrix A(i);
		Vector b(i);
		Vector xIn(i);
		Vector xOut1(i);
		Vector xOut2(i);

		double** aPtr = A.getPtr();
		double* bPtr = b.getPtr();


		Generator::generateEq(A,xIn,b);


		clock_t start, stop;
		double CPUTime = 0, CUDATime = 0;

		start = clock();
		if(Solver::LUSolveCPU(A,xOut1,b))
		{
			//Repeat calculations
			i-=50;
			continue;
		}
		stop = clock();
		CPUTime = (double)(stop-start)*1000/(CLOCKS_PER_SEC);

		start = clock();
		Solver::LUSolveCUDA(A,xOut2,b);

		stop = clock();
		CUDATime = (double)(stop-start)*1000/(CLOCKS_PER_SEC);

		//xIn.print();
		//xOut1.print();
		//xOut2.print();

		//Checking results
		bool error = false;
		for(int x = 0;x<i;x++)
		{
			double val1 = xIn.getVal(x);
			double val2 = xOut1.getVal(x);
			double val3 = xOut2.getVal(x);

			if(fabs(val1 - val2)>0.1 || fabs(val1 - val3)>0.1 )
			{
				error = true;
			}

		}

		if(error)
		{

			file << "Results mismatch" << std::endl;
			std::cout << "Results mismatch" << std::endl;
			return 0;
		}


		file << i << " " << CPUTime << " " << CUDATime << std::endl;
		std::cout << i << " " << CPUTime << " " << CUDATime << std::endl;



	}

	file.close();

	return 0;
}
