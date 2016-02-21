################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CU_SRCS += \
../src/Solver.cu 

CPP_SRCS += \
../src/Generator.cpp \
../src/Matrix.cpp \
../src/Vector.cpp \
../src/main.cpp 

OBJS += \
./src/Generator.o \
./src/Matrix.o \
./src/Solver.o \
./src/Vector.o \
./src/main.o 

CU_DEPS += \
./src/Solver.d 

CPP_DEPS += \
./src/Generator.d \
./src/Matrix.d \
./src/Vector.d \
./src/main.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: NVCC Compiler'
	/usr/local/cuda-7.5/bin/nvcc -G -g -O0 -gencode arch=compute_20,code=sm_20 -gencode arch=compute_20,code=sm_21  -odir "src" -M -o "$(@:%.o=%.d)" "$<"
	/usr/local/cuda-7.5/bin/nvcc -G -g -O0 --compile  -x c++ -o  "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

src/%.o: ../src/%.cu
	@echo 'Building file: $<'
	@echo 'Invoking: NVCC Compiler'
	/usr/local/cuda-7.5/bin/nvcc -G -g -O0 -gencode arch=compute_20,code=sm_20 -gencode arch=compute_20,code=sm_21  -odir "src" -M -o "$(@:%.o=%.d)" "$<"
	/usr/local/cuda-7.5/bin/nvcc -G -g -O0 --compile --relocatable-device-code=false -gencode arch=compute_20,code=compute_20 -gencode arch=compute_20,code=sm_21  -x cu -o  "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


