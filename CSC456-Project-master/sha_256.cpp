#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <string.h>
#include <math.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <ctime>
#include <string>
#include "CL/opencl.h"
#include "AOCL_Utils.h"
using namespace aocl_utils;
// OpenCL runtime configuration
cl_platform_id platform = NULL;
unsigned num_devices = 0;
scoped_array<cl_device_id> device; // num_devices elements
cl_context context = NULL;
scoped_array<cl_command_queue> queue; // num_devices elements
cl_program program = NULL;
scoped_array<cl_kernel> kernel; // num_devices elements
cl_uint *out; //output buffer


bool init_opencl();
void cleanup();

bool init_opencl() {
  int err;
  cl_int status;

  printf("Initializing OpenCL\n");
#ifdef APPLE
  int gpu = 1;
  err = clGetDeviceIDs(NULL, gpu ? CL_DEVICE_TYPE_GPU : CL_DEVICE_TYPE_CPU, 1, &device, NULL);
  if (err != CL_SUCCESS)
  {
    fprintf(stderr, "Error: Failed to create a device group!\n");
    return EXIT_FAILURE;
  }
  // Create the context.
  context = clCreateContext(NULL, 1, &device[0], NULL, NULL, &status);
  checkError(status, "Failed to create context");
#else 
  if(!setCwdToExeDir()) {
    return false;
  }

  // Get the OpenCL platform.
  platform = findPlatform("Altera");
 if(platform == NULL) {
   printf("ERROR: Unable to find Altera OpenCL platform.\n");
   return false;
 }

  // Query the available OpenCL device.
  device.reset(getDevices(platform, CL_DEVICE_TYPE_ALL, &num_devices));
  printf("Platform: %s\n", getPlatformName(platform).c_str());
  printf("Using %d device(s)\n", num_devices);
  for(unsigned i = 0; i < num_devices; ++i) {
    printf("  %s\n", getDeviceName(device[i]).c_str());
  }
  // Create the context.
  context = clCreateContext(NULL, num_devices, device, NULL, NULL, &status);
#endif

  // Create the program for all device. Use the first device as the
  // representative device (assuming all device are of the same type).
#ifndef APPLE
  std::string binary_file = getBoardBinaryFile("sha256", device[0]);
  printf("Using AOCX: %s\n", binary_file.c_str());
  program = createProgramFromBinary(context, binary_file.c_str(), device, num_devices);

  // Build the program that was just created.
  status = clBuildProgram(program, 0, NULL, "", NULL, NULL);

  //Create per-device objects.
  queue.reset(num_devices);
  kernel.reset(num_devices);
  for(unsigned i = 0; i < num_devices; ++i) {
    // Command queue.
    queue[i] = clCreateCommandQueue(context, device[i], CL_QUEUE_PROFILING_ENABLE, &status);

    // Kernel.
    const char *kernel_name = "sha256";
    kernel[i] = clCreateKernel(program, kernel_name, &status);

  }
#else
  char *source = 0;
  size_t length = 0;
  LoadTextFromFile("sha256.cl", &source, &length);
  const char *kernel_name = "sha256";
  program = clCreateProgramWithSource(context, 1, (const char **) & source, NULL, &err);

  // Build the program that was just created.
  status = clBuildProgram(program, 0, NULL, NULL, NULL, NULL);

  queue = clCreateCommandQueue(context, device, CL_QUEUE_PROFILING_ENABLE, &status);
  kernel = clCreateKernel(program, kernel_name, &status);
#endif
  return true;
}

const int SHA256_PLAINTEXT_LENGTH = 64;
const int SHA256_BINARY_SIZE = 32;
const int SHA256_RESULT_SIZE = 8;
const size_t global_work_size = 1;

int main ( int argc, char** argv ) {
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

  cl_command_queue queue = clCreateCommandQueue(context, device[0], CL_QUEUE_PROFILING_ENABLE, &status);

  //Create data buffer
  cl_mem data_buf = clCreateBuffer(context, CL_MEM_READ_WRITE, sizeof(unsigned int) * 3, NULL, &status);

  // Transfer data to the device.
  status = clEnqueueWriteBuffer(queue, data_buf, CL_FALSE, 0, sizeof(unsigned int) * 3, data, 0, NULL, &write_event[0]);

  // Create input buffer
  cl_mem in_buf = clCreateBuffer(context, CL_MEM_WRITE_ONLY, 
      3 * sizeof(unsigned int), NULL, &status);

  // Transfer input buffer to the device
  status = clEnqueueWriteBuffer(queue, in_buf, CL_FALSE, 0, SHA256_PLAINTEXT_LENGTH * 4, input, 0, NULL, &write_event[1]);
  
  cl_mem out_buf = clCreateBuffer(context, CL_MEM_WRITE_ONLY, sizeof(cl_uint) * SHA256_RESULT_SIZE, NULL, &status);

 
  // Set kernel arguments.
  unsigned argi = 0;

  status = clSetKernelArg(kernel[0], argi++, sizeof(cl_mem), &data_buf);
  status = clSetKernelArg(kernel[0], argi++, sizeof(cl_mem), &in_buf);
  status = clSetKernelArg(kernel[0], argi++, sizeof(cl_mem), &out_buf);

  // Enqueue kernel
  // Events are used to ensure that the kernel is not launched until
  // the write to the input buffer has been completed.
    
  status = clEnqueueNDRangeKernel(queue, kernel[0], 1, NULL, &global_work_size, NULL, 1, write_event, &kernel_event);

  // Read the result. This is the final operation.
  status = clEnqueueReadBuffer(queue, out_buf, CL_FALSE, 0, sizeof(cl_uint) * SHA256_RESULT_SIZE, out, 1, &kernel_event, &finish_event[0]);
  printf("Hash: %u.\n", out);
  clReleaseEvent(write_event[0]);
  clReleaseEvent(write_event[1]);

  // Wait for device to finish.
  clWaitForEvents(num_devices, finish_event);

  clReleaseEvent(kernel_event);
  clReleaseEvent(finish_event[0]);

  return 0;
}

void cleanup(){

}

