#!/bin/sh
yacc -y -d -t -v stackmachine.y                         # generate y.tab.c, y.tab.h
cc y.tab.c -Wall -Wno-unused-function -o stackmachine   # compile and link
