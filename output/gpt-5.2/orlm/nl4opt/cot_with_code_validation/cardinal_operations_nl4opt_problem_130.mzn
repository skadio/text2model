% Parameters
int: prodA = 30;
int: prodB = 50;
int: kwhA  = 100;
int: kwhB  = 120;

int: minItems = 1000;
int: maxKwh   = 3000;

float: maxFracB = 0.30;
int: minA = 5;

% Variables
var 0..ceil(int2float(minItems) / int2float(prodA)): nA;
var 0..ceil(int2float(minItems) / int2float(prodB)): nB;
var 0..ceil(int2float(minItems) / int2float(prodA)) + ceil(int2float(minItems) / int2float(prodB)): nTotal;

% Constraints
constraint nA >= minA;
constraint nTotal = nA + nB;

constraint prodA * nA + prodB * nB >= minItems;
constraint kwhA * nA + kwhB * nB <= maxKwh;

% at most 30% of machines are type B: nB <= 0.30 * (nA + nB)
constraint 10 * nB <= 3 * nTotal;

% Objective
solve minimize nTotal;