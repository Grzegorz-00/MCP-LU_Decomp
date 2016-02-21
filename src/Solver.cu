#include "Solver.h"


__global__ void computeRow(double* aPtr, int i, int size, int* error)
{
	int idx = blockIdx.x * blockDim.x + threadIdx.x;
	if(*error != 0)return;
	int j = idx+i;
	if(j >= i && j<size)
	{
		double sum = 0;
		for(int k = 0;k<i;k++)
		{
			sum+=aPtr[k*size + i]*aPtr[j*size + k];
		}
		aPtr[j*size + i] -= sum;
	}
}
__global__ void computeCol(double* aPtr, int i, int size, int* error)
{
	int idx = blockIdx.x * blockDim.x + threadIdx.x;
	if(*error != 0)return;
	int j = idx+i;

	if(j >= i+1 && j<size)
	{
		double sum = 0;
		for(int k = 0;k<i;k++)
		{
			sum+=aPtr[k*size + j]*aPtr[i*size + k];
		}
		aPtr[i*size + j] -=sum;
		if(aPtr[i*size + i] == 0)
		{
			*error = 1;
			return;
		}
		aPtr[i*size + j] = aPtr[i*size + j]/aPtr[i*size + i];

	}
	//return;
}

int Solver::LUSolveCPU(Matrix& A, Vector& x, Vector& b)
{
	int size = A.getSize();
	double** temp = A.getPtr();
	double** aPtr = new double*[size];
	for(int i = 0;i<size;i++)
	{
		aPtr[i] = new double[size];
	}

	for(int i = 0;i<size;i++)
	{
		for(int j = 0;j<=size;j++)
		{
				aPtr[i][j] = temp[i][j];
		}
	}


	double* bPtr = b.getPtr();
	double* xPtr = x.getPtr();
	//LU decompose

	for(int x = 0;x<size;x++)
	{
		for(int y = 0;y<=x;y++)
		{
			double sum = 0;
			for(int i = 0;i<y;i++)
			{
				sum+=aPtr[i][y]*aPtr[x][i];
			}
			aPtr[x][y] -= sum;
		}

		for(int y = x+1;y<size;y++)
		{
			double sum = 0;
			for(int i = 0;i<x;i++)
			{
				sum+=aPtr[i][y]*aPtr[x][i];
			}
			aPtr[x][y] -=sum;
			if(aPtr[x][x] == 0)
			{
				return 1;
			}
			aPtr[x][y] = aPtr[x][y]/aPtr[x][x];

		}
	}





	//Solve eq
	//L*z = b;

	double* yVect = new double[size];

	for(int y = 0;y<size;y++)
	{
		double sum = 0;
		for(int x = 0;x<y;x++)
		{
			sum += aPtr[x][y]*yVect[x];
		}
		yVect[y] = bPtr[y] - sum;
	}


	for(int y = size-1;y>=0;y--)
	{
		double sum = 0;
		for(int x = y+1;x<size;x++)
		{
			sum+= aPtr[x][y]*xPtr[x];
		}
		xPtr[y] = (yVect[y] - sum)/aPtr[y][y];
	}

	for(int i = 0;i<size;i++)
	{
		delete[] aPtr[i];
	}
	delete[] aPtr;
	delete[] yVect;
	return 0;
}



int Solver::LUSolveCUDA(Matrix& A, Vector& x, Vector& b)
{
	int size = A.getSize();
	double** temp = A.getPtr();
	double** aPtr = new double*[size];
	int error = 0;

	for(int i = 0;i<size;i++)
	{
		aPtr[i] = new double[size];
	}

	double* a2Ptr = new double[size*size];
	double* bPtr = b.getPtr();
	double* xPtr = x.getPtr();

	for(int x = 0;x<size;x++)
	{
		for(int y = 0;y<size;y++)
		{
			a2Ptr[x*size+y] = temp[x][y];
		}
	}

	int* cudaErrorPtr;
	double* cudaAPtr;
	if(cudaSuccess != cudaMalloc((void**)&cudaAPtr,sizeof(double)*size*size))printf("malloc error");
	if(cudaSuccess != cudaMalloc((void**)&cudaErrorPtr,sizeof(int)))printf("malloc error");
	if(cudaSuccess != cudaMemcpy(cudaAPtr,a2Ptr,sizeof(double)*size*size,cudaMemcpyHostToDevice))printf("memcpy error");
	if(cudaSuccess != cudaMemcpy(cudaErrorPtr,&error,sizeof(int),cudaMemcpyHostToDevice))printf("memcpy error");




	//LU decompose
	for(int i = 0;i<size;i++)
	{
		int block_size = 512;
		int block_num = ((size-i) + block_size - 1)/block_size;
		computeRow <<<block_num,block_size>>>(cudaAPtr, i, size, cudaErrorPtr);
		computeCol <<<block_num,block_size>>>(cudaAPtr, i, size, cudaErrorPtr);
		if(cudaSuccess != cudaMemcpy(&error,cudaErrorPtr,sizeof(int),cudaMemcpyDeviceToHost))printf("memcpy error");
		if(error != 0) return 1;
	}


	if(cudaSuccess != cudaMemcpy(a2Ptr,cudaAPtr,sizeof(double)*size*size,cudaMemcpyDeviceToHost))printf("memcpy error");

	cudaFree(cudaAPtr);
	cudaFree(cudaErrorPtr);

	for(int x = 0;x<size;x++)
	{
		for(int y = 0;y<size;y++)
		{
			aPtr[x][y] = a2Ptr[x*size+y];

		}

	}


	//Solve eq
	//L*z = b;

	double* yVect = new double[size];

	for(int y = 0;y<size;y++)
	{
		double sum = 0;
		for(int x = 0;x<y;x++)
		{
			sum += aPtr[x][y]*yVect[x];
		}
		yVect[y] = bPtr[y] - sum;
	}



	for(int y = size-1;y>=0;y--)
	{
		double sum = 0;
		for(int x = y+1;x<size;x++)
		{
			sum+= aPtr[x][y]*xPtr[x];
		}
		xPtr[y] = (yVect[y] - sum)/aPtr[y][y];
	}
	for(int i = 0;i<size;i++)
	{
		delete[] aPtr[i];
	}
	delete[] aPtr;
	delete[] yVect;
	return 0;
}
