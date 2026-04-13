% Parameters
int: n = 6;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
  [| 0, 65, 41, 14, 16, 35
   | 65, 0, 76, 52, 89, 45
   | 41, 76, 0, 72, 38, 62
   | 14, 52, 72, 0, 22, 24
   | 16, 89, 38, 22, 0, 89
   | 35, 45, 62, 24, 89, 0 |];

% Variables
array[CITIES, CITIES] of var 0..1: x;   % x[i,j] = 1 if tour goes directly from i to j
array[CITIES] of var 1..n: u;           % MTZ order variables
var int: total_cost;

% Constraints
constraint
  forall(i in CITIES) (x[i,i] = 0);

constraint
  forall(i in CITIES) (sum(j in CITIES)(x[i,j]) = 1);  % exactly one outgoing edge

constraint
  forall(j in CITIES) (sum(i in CITIES)(x[i,j]) = 1);  % exactly one incoming edge

% Fix a root for MTZ (symmetry breaking)
constraint
  u[1] = 1;
constraint
  forall(i in 2..n) (u[i] >= 2 /\ u[i] <= n);

% MTZ subtour elimination
constraint
  forall(i in 2..n, j in 2..n where i != j) (
    u[i] - u[j] + n * x[i,j] <= n - 1
  );

constraint
  total_cost = sum(i in CITIES, j in CITIES)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;