#include <stdio.h>

#ifdef __APPLE__
#define _expr() expr()
#endif

extern long _expr();  // use external _expr() in simple.s

int main(void) {
    long e = _expr();
    printf("%ld\n", e);
    return 0;
}
