% Parameters
int: n = 10;
set of int: FLIGHTS = 1..n;

array[FLIGHTS] of int: a = [40, 11, 35, 38, 74, 87, 62, 75, 94, 128];
array[FLIGHTS] of int: b = [67, 87, 94, 96, 105, 137, 121, 143, 172, 151];

int: minA = min(a);
int: maxB = max(b);

% Variables
array[FLIGHTS] of var int: t;        % landing times
var 0..(maxB - minA): d;             % minimum separation time

% Constraints
constraint forall(j in FLIGHTS) (
  a[j] <= t[j] /\ t[j] <= b[j]
);

constraint forall(j in 1..n-1) (
  t[j+1] - t[j] >= d
);

% Objective
solve maximize d;