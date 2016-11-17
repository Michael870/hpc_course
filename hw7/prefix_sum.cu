/**
 * University of Pittsburgh
 * Department of Computer Science
 * CS1645: Introduction to HPC Systems
 * Instructor: Xiaolong Cui
 * This is a skeleton for implementing prefix sum using GPU, inspired
 * by nvidia course of similar name.
 */

#include <stdio.h>
#include <math.h>
#include <string.h>

#define N 512

/*
 * You should implement the parallel scan function here!
 */
__global__ void parallel_scan(float *g_odata, float *g_idata, int n) {


}



/*
 * Fills an array a with n random floats.
 */
void random_floats(float* a, int n) {
  float d;
  // Comment out this line if you want consistent "random".
  srand(time(NULL));
  for (int i = 0; i < n; ++i) {
    d = rand() % 8;
    a[i] = ((rand() % 64) / (d > 0 ? d : 1));
  }
}

/*
 * Simple Serial implementation of exclusive scan.
 */
void serial_scan(float* out, float* in, int n) {
  float total_sum = 0;
  out[0] = 0;
  for (int i = 1; i < n; i++) {
    total_sum += in[i-1];
    out[i] = out[i-1] + in[i-1];
  }
  if (total_sum != out[n-1]) {
    printf("Warning: exceeding accuracy of float.\n");
  }
}

/*
 * This is a simple function that confirms that the output of the scan
 * function matches that of a golden image (array).
 */
bool printError(float *gold_out, float *test_out, bool show_all) {
  bool firstFail = true;
  bool error = false;
  float epislon = 0.1;
  float diff = 0.0;
  for (int i = 0; i < N; ++i) {
    diff = abs(gold_out[i] - test_out[i]);
    if ((diff > epislon) && firstFail) {
      printf("ERROR: gold_out[%d] = %f != test_out[%d] = %f // diff = %f \n", i, gold_out[i], i, test_out[i], diff);
      firstFail = show_all;
      error = true;
    }
  }
  return error;
}

int main(void) {
  float *in, *out, *gold_out; // host

  int size = sizeof(float) * N;


  
  in = (float *)malloc(size);
  random_floats(in, N);
  out = (float *)malloc(size);
  gold_out = (float *)malloc(size);

  // ***********
  // RUN SERIAL SCAN
  // ***********
  serial_scan(gold_out, in, N);


  // ***********
  // RUN PARALLEL SCAN
  // ***********



  if (printError(gold_out, out, false)) {
    printf("ERROR: The parallel scan function failed to produce proper output.\n");
  } else {
    printf("CONGRATS: The parallel scan function produced proper output.\n");
  }

  

  return 0;
}
