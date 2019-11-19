#!/bin/sh
../postfix64/postfix64 < simple.in >> simple.s   # generate x86-64 code for expression
cc simple.s simple.c -o simple                   # compile and link the .s and .c files
./simple                                         # evaluate the expression (the result is 64)
