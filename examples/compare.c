#include <stdio.h>

#define N 800

long a[] = {1, 2, 3};

extern long expr();     // use external expr() in compare.s
long expr1() { return 1+(a[0]+(a[1]-a[2])*345-123*(a[2]%a[1]*a[0]+1)%a[1]+a[2]%(a[1]+123+a[0]/7))-a[1]+a[0]*a[1]/531%a[1]; }

int main(void) {
	long i, j, k, sum = 0;
	for(i = 0; i < N; i++) {
		for(j = 0; j < N; j++) {
		    for(k = 0; k < N; k++) {
			    sum += expr();           // evaluate the expression millions of times
			    a[0] += i;
			    a[1] += j;
			    a[2] += k;
                if(expr() != expr1()) {  // check if C version differs from the ASM version
                    printf("error: expressions differ\n");
                    return 0;
                }
            }
		}
		printf("%ld\n", sum);
	}
    return 0;
}
