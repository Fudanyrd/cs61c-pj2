#include <stdio.h>
#include <stdlib.h>
// this is a pseudo c code of function dot.
int dot(int* a0, int* a1, int a2, int a3, int a4) {
    if (a2 < 1) {
        exit(5);
    } 
    if(a3 < 1 || a4 < 1) {
        exit(6);
    }
    int t0 = 0, t1 = 0;
    while(t1 < a2) {
        t0 += a0[t1 * a3] * a1[t1 * a4];
        ++t1;
    }
    return t0;
}

// this is a pseudo c code version of matmul.
void matmul(
    int *a0, // matrix 0
    int a1,  // # of rows of m0
    int a2,  // # of cols of m0
    int *a3, // matrix 1
    int a4,  // # of rows of m1
    int a5,  // # of cols of m1
    int *a6  // store the result.
) {
    if(a1 < 1 || a2 < 1) {
        exit(2);
    }
    if(a4 < 1 || a5 < 1) {
        exit(3);
    }
    if(a2 != a4) {
        exit(4);
    }

    const int *s0 = a0, *s1 = a3, *s2 = a6;
    const int s3 = 1;
    for(int r = 0; r < a1; ++r) {
        for(int c = 0; c < a5; ++c) {
            // store a0-a6, ra
            s2[r * a5 + c] = dot((s0 + a2 * r), (s1 + c), a2, 1, a5);
            // restore a0-a6, ra
        }
    }
}