#ifndef POLY_H
#define POLY_H

#include <stdint.h>
#include "params.h"

/*
 * Elements of R_q = Z_q[X]/(X^n + 1). Represents polynomial
 * coeffs[0] + X*coeffs[1] + X^2*xoeffs[2] + ... + X^{n-1}*coeffs[n-1]
 */
typedef struct {
  int16_t coeffs[NEWHOPECMPCT_N] __attribute__((aligned(32)));
} poly;

void poly_uniform(poly *a, const unsigned char *seed);
void poly_sample(poly *r, const unsigned char *seed, unsigned char nonce);
void poly_add(poly *r, const poly *a, const poly *b);

void poly_ntt(poly *r);
void poly_invntt(poly *r);
void poly_basemul(poly *r, const poly *a, const poly *b);

void poly_frombytes(poly *r, const unsigned char *a);
void poly_tobytes(unsigned char *r, const poly *p);
void poly_compress(unsigned char * restrict r, const poly * restrict p);
void poly_decompress(poly * restrict r, const unsigned char * restrict a);

void poly_frommsg(poly *r, const unsigned char *msg);
void poly_tomsg(unsigned char *msg, const poly *x);
void poly_sub(poly *r, const poly *a, const poly *b);

#endif
