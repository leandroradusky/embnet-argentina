#!/bin/bash
/usr/bin/g++ -static -Wall -W -fno-strength-reduce -I/opt/BALL-1.3.0/include -I/opt/BALL-1.3.0/contrib/include -c $1.C -o $1.o
/usr/bin/g++ -static -o $1 $1.o -L/opt/BALL-1.3.0/contrib/lib -lgsl -lgslcblas -L/opt/BALL-1.3.0/lib -lBALL -L/opt/blitz-0.9/lib -lm -L/usr/local/lib -lm

