  // CSC456: Name Will Rea
  // CSC456: Student ID # 200024836
  // CSC456: Student Unity ID: wcrea
  // CSC456: I am implementing Merge Sort {What parallel sorting algorithm using pthread}
  // CSC456: Feel free to modify any of the following. You can only turnin this file.

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <float.h>
#include <sys/time.h>
#include <pthread.h>
#include "mysort.h"

struct thread_data {
  float *data;
  int p;
  int r;
};

// Takes in an array that has two sorted subarrays,
//  from [p..q] and [q+1..r], and merges the array
void merge( float *data, int p, int q, int r ) {
  int lowSize = q - p + 1;
  int highSize = r - q;
  float * lowHalf, * highHalf;
  lowHalf = (float*) malloc(lowSize*sizeof(float));
  highHalf = (float*) malloc(highSize*sizeof(float));
  
  if (lowHalf == NULL ) exit(1);
  if (highHalf == NULL ) exit(1);

  int k = p;
  int i = 0;
  int j = 0;

  for (i = 0; k <= q; i++, k++) {
    lowHalf[i] = data[k];
  }
  for (j = 0; k <= r; j++, k++) {
    highHalf[j] = data[k];
  }

  k = p;
  i = 0;
  j = 0;

  // Repeatedly check each half array for the 
  // smallest value and put that back in the
  // original array.
  while ( i < lowSize && j < highSize ) {
    if ( lowHalf[i] < highHalf[j] ) {
      data[k] = lowHalf[i];
      k++;
      i++;
    }
    else {
      data[k] = highHalf[j];
      k++;
      j++;
    }
  }

  // Once one of the half arrays is empty
  // take all of the remaining values from
  // the other and put them in data.
  while ( i < lowSize ) {
    data[k] = lowHalf[i];
    k++;
    i++;
  }
  while ( j < highSize ) {
    data[k] = highHalf[j];
    k++;
    j++;
  }

  free( lowHalf );
  free( highHalf );
}

// Given a sub array with starting point p and
// end point r, sort the sub array data[p..r]
void merge_sort( float *data, int p, int r ) {
  if ( p < r ) {
    int q = (p + r) / 2;
    merge_sort( data, p, q );
    merge_sort( data, q+1, r );
    merge( data, p, q, r );
  }
}

void *thread_merge( void *threadArgs ) {
  struct thread_data *info;
  info = (struct thread_data *) threadArgs;
  merge_sort( info->data, info->p, info->r);

  pthread_exit(NULL);
}

int pthread_sort(int num_of_elements, float *data)
{
  const int numThreads = 4;
  int numPerThread = num_of_elements / numThreads;
  pthread_t threads[numThreads];
  pthread_attr_t attr;
  void *status;
  struct thread_data td[numThreads];
  int threadInit;

  pthread_attr_init( &attr );
  pthread_attr_setdetachstate( &attr, PTHREAD_CREATE_JOINABLE );

  // create the threads and pass them the data they need to run.
  for ( int i = 0; i < numThreads; i++ ) {
    td[i].data = data;
    td[i].p = i * numPerThread;
    td[i].r = (i+1) * numPerThread - 1;
    threadInit = pthread_create(&threads[i], NULL, thread_merge, (void *) &td[i]);

    if (threadInit) {
      printf("Error: unable to create thread, %d\n", threadInit);
      exit(-1);
    }
  } 

  // Wait for all threads to finish then join them
  pthread_attr_destroy( &attr );
  for ( int i = 0; i < numThreads; i++ ) {
    threadInit = pthread_join(threads[i], &status);

    if (threadInit) {
      printf("Error: unable to create thread, %d\n", threadInit);
      exit(-1);
    }
  }

  // Now merge the 4 seperate arrays created by the threads
  merge( data, td[0].p, td[0].r, td[1].r );
  merge( data, td[2].p, td[2].r, td[3].r );
  merge( data, td[0].p, td[1].r, td[3].r );
  
//  merge_sort( data, 0, num_of_elements - 1 );
  return 0;
}

