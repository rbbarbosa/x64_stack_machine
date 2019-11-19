#include <stdio.h>

extern long expression();  // use external expression() in simple.s

int main(void) {
    long e = expression();
    printf("%ld\n", e);
    return 0;
}
