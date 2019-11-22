#include <stdio.h>

#ifndef __APPLE__
#define expr() _expr()
#endif

extern long expr();  // use external expr() in simple.s

int main(void) {
    long e = expr();
    printf("%ld\n", e);
    return 0;
}
