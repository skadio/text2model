% Parameters
int: wN1 = 3;
int: wN2 = 2;
int: wD1 = 4;
int: wD2 = 5;

int: minN = 10;
int: minD = 8;

int: maxDiffN1D1 = 4;
int: maxDiffN2D2 = 3;

% Variables
var 0..100: hN1;
var 0..100: hN2;
var 0..100: hD1;
var 0..100: hD2;

var 0..10000: total_workload;

% Constraints
constraint hN1 + hN2 >= minN;
constraint hD1 + hD2 >= minD;

constraint abs(hN1 - hD1) <= maxDiffN1D1;
constraint abs(hN2 - hD2) <= maxDiffN2D2;

constraint total_workload = wN1*hN1 + wN2*hN2 + wD1*hD1 + wD2*hD2;

% Objective
solve minimize total_workload;