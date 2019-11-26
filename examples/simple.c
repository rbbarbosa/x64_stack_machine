#include <stdio.h>

extern long expr();  // use external expr() in simple.s

int main(void) {
    long e = expr();
    printf("%ld\n", e);
    return 0;
}
