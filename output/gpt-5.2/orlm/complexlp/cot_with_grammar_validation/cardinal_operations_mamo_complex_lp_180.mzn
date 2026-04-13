% Parameters
int: n = 10;
set of int: FLIGHTS = 1..n;

array[FLIGHTS] of int: a = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90];
array[FLIGHTS] of int: b = [60, 70, 80, 90, 100, 110, 120, 130, 140, 150];

int: minA = min([a[i] | i in FLIGHTS]);
int: maxB = max([b[i] | i in FLIGHTS]);

% Variables
array[FLIGHTS] of var int: t;          % landing times
var 0..(maxB - minA): s;               % minimum separation time

% Constraints
constraint forall(i in FLIGHTS) (t[i] >= a[i]);
constraint forall(i in FLIGHTS) (t[i] <= b[i]);

constraint forall(i in 1..n-1) (t[i+1] >= t[i] + s);

% Objective
solve maximize s;