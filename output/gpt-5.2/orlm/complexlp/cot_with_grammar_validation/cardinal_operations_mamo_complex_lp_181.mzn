% Parameters
int: n = 10;
set of int: F = 1..n;

array[F] of int: a = [40, 11, 35, 38, 74, 87, 62, 75, 94, 128];
array[F] of int: b = [67, 87, 94, 96, 105, 137, 121, 143, 172, 151];

int: LB = min(a);
int: UB = max(b);

% Variables
array[F] of var LB..UB: t;     % landing times
var 0..(UB - LB): s;           % minimum separation (to maximize)

% Constraints
constraint forall(j in F)(
  t[j] >= a[j] /\ t[j] <= b[j]
);

constraint forall(j in 1..n-1)(
  t[j+1] >= t[j] + s
);

% Objective
solve maximize s;