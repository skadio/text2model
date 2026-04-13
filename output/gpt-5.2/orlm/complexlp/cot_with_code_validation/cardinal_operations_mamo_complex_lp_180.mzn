% Parameters
int: n = 10;
set of int: FLIGHTS = 1..n;

array[FLIGHTS] of int: a = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90];
array[FLIGHTS] of int: b = [60, 70, 80, 90, 100, 110, 120, 130, 140, 150];

int: minA = min(a);
int: maxB = max(b);

% Variables
array[FLIGHTS] of var int: t;
var 0..(maxB - minA): s;

% Constraints
constraint forall(j in FLIGHTS) (
  t[j] >= a[j] /\ t[j] <= b[j]
);

constraint forall(j in 1..n-1) (
  t[j+1] - t[j] >= s
);

constraint forall(j in 1..n-1) (
  t[j+1] >= t[j]
);

% Objective
solve maximize s;