#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <string.h>
#include <math.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <ctime>
#include <string>
#include "CL/opencl.h"
#include "AOCL_Utils.h"
using namespace aocl_utils;
// OpenCL runtime configuration
cl_platform_id platform = NULL;
unsigned num_devices = 1;
cl_device_id device;
cl_context context = NULL;
cl_command_queue queue;
cl_program program = NULL;
cl_kernel kernel;
cl_uint *out; //output buffer


bool init_opencl();
cl_program build_program(cl_context ctx, cl_device_id dev, const char* filename);
void cleanup();

bool init_opencl() {
	int err;
	cl_int status;

	printf("Initializing OpenCL\n");
	clGetPlatformIDs(1, &platform, NULL);

	err = clGetDeviceIDs(platform, CL_DEVICE_TYPE_GPU, 1, &device, NULL);
	if (err != CL_SUCCESS) {
		fprintf(stderr, "Error: Failed to create a device group!\n");
		return EXIT_FAILURE;
	}

	// Create the context.
	context = clCreateContext(NULL, 1, &device, NULL, NULL, &status);
	checkError(status, "Failed to create context");

	program = build_program(context, device, "sha256.cl");

	kernel = clCreateKernel(program, "sha256", &err);
	checkError(err, "Failed to create kernel");

	queue = clCreateCommandQueue(context, device, CL_QUEUE_PROFILING_ENABLE, &status);
	checkError(status, "Failed to create command queue");

	return true;
}

const int SHA256_PLAINTEXT_LENGTH = 64;
const int SHA256_BINARY_SIZE = 32;
const int SHA256_RESULT_SIZE = 8;
const size_t global_work_size = 1;
static size_t local_work_size = 1;

int main(int argc, char** argv) {
	init_opencl();
	
	// Necessary declarations
	cl_int status;
	const char *input = "0123456789012345678901234567890123456789012345678901234567890123456789"; // The string to be hashed
	int len = strlen(input); // The length of the input string
	unsigned int data[3]; // Necessary info for sha256 kernel
	data[0] = SHA256_PLAINTEXT_LENGTH; // The length required for SHA256
	data[1] = global_work_size; // global worksize = 1
	data[2] = len; // the length of the input string

	cl_event kernel_event;
	scoped_array<cl_event> finish_event(num_devices);
	cl_event write_event[2];

	//cl_command_queue queue = clCreateCommandQueue(context, device, CL_QUEUE_PROFILING_ENABLE, &status);

	//Create data buffer
	cl_mem data_buf = clCreateBuffer(context, CL_MEM_READ_WRITE, sizeof(cl_uint) * 3, NULL, &status);

	// Transfer data to the deviceUsed.
	status = clEnqueueWriteBuffer(queue, data_buf, CL_FALSE, 0, sizeof(cl_uint) * 3, data, 0, NULL, NULL);

	// Create input buffer
	cl_mem in_buf = clCreateBuffer(context, CL_MEM_WRITE_ONLY,
		3 * sizeof(cl_uint), NULL, &status);

	// Transfer input buffer to the deviceUsed
	status = clEnqueueWriteBuffer(queue, in_buf, CL_FALSE, 0, SHA256_PLAINTEXT_LENGTH * 2048 * sizeof(cl_uint), input, 0, NULL, NULL);

	cl_mem out_buf = clCreateBuffer(context, CL_MEM_WRITE_ONLY, sizeof(cl_uint) * SHA256_RESULT_SIZE, NULL, &status);


	// Set kernel arguments.
	unsigned argi = 0;
	
	status = clSetKernelArg(kernel, argi++, sizeof(cl_mem), &data_buf);
	status = clSetKernelArg(kernel, argi++, sizeof(cl_mem), &in_buf);
	status = clSetKernelArg(kernel, argi++, sizeof(cl_mem), &out_buf);
	
	// Enqueue kernel
	// Events are used to ensure that the kernel is not launched until
	// the write to the input buffer has been completed.
	status = clEnqueueNDRangeKernel(queue, kernel, 1, NULL, &global_work_size, &local_work_size, 0, NULL, NULL);
	
	clFinish(queue);

	// Read the result. This is the final operation.
	status = clEnqueueReadBuffer(queue, out_buf, CL_FALSE, 0, sizeof(cl_uint) * SHA256_RESULT_SIZE, out, 0, NULL, NULL);
	printf("Hash %u\n", out);
	//clReleaseEvent(write_event[0]);
	
	//clReleaseEvent(write_event[1]);
	
	// Wait for device to finish.
	//clWaitForEvents(num_devices, finish_event);

	//clReleaseEvent(kernel_event);
	//clReleaseEvent(finish_event[0]);

	return 0;
}

/* Create program from a file and compile it */
cl_program build_program(cl_context ctx, cl_device_id dev, const char* filename) {
	cl_program program;
	FILE *program_handle;
	char *program_buffer, *program_log;
	size_t program_size, log_size;
	int err;
	//Read program file and place content into buffer
	program_handle = fopen(filename, "r");
	if (program_handle == NULL) {
		perror("Couldn't find the program file");
		exit(1);
	}
	fseek(program_handle, 0, SEEK_END);
	program_size = ftell(program_handle);
	rewind(program_handle);
	program_buffer = (char*)malloc(program_size + 1);
	program_buffer[program_size] = '\0';
	program_size = fread(program_buffer, sizeof(char), program_size, program_handle);
	fclose(program_handle);

	//Create program from file
	program = clCreateProgramWithSource(ctx, 1,
		(const char**)&program_buffer, (const size_t *)&program_size, &err);
	free(program_buffer);

	/* Build program */
	err = clBuildProgram(program, 0, NULL, NULL, NULL, NULL);
	if (err == CL_BUILD_PROGRAM_FAILURE) {
		// Determine the size of the log
		size_t log_size;
		clGetProgramBuildInfo(program, device, CL_PROGRAM_BUILD_LOG, 0, NULL, &log_size);

		// Allocate memory for the log
		char *log = (char *)malloc(log_size);

		// Get the log
		clGetProgramBuildInfo(program, device, CL_PROGRAM_BUILD_LOG, log_size, log, NULL);

		// Print the log
		printf("%s\n", log);
		free(log);
	}
	checkError(err, "Failed to build program");

	return program;
}

void cleanup() {
	clReleaseKernel(kernel);
	clReleaseCommandQueue(queue);
	clReleaseProgram(program);
	clReleaseContext(context);
}