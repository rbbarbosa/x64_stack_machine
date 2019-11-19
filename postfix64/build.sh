#!/bin/sh
yacc -y -d -t -v postfix64.y                         # generate y.tab.c, y.tab.h
cc y.tab.c -Wall -Wno-unused-function -o postfix64   # compile and link
