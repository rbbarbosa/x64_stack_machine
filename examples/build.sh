#!/bin/sh
../postfix64/postfix64 < simple.in > simple.s     # generate x86-64 code for expression in simple.in
cc simple.s simple.c -o simple                    # compile and link the .s and .c files

../postfix64/postfix64 < compare.in > compare.s   # generate x86-64 code for expression in simple.in
cc -O0 compare.s compare.c -o compare             # compile and link the .s and .c files
