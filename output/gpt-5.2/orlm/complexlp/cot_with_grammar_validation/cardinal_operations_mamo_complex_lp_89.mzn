% Parameters
int: N = 5;
set of int: CITIES = 1..N;

array[CITIES, CITIES] of int: cost =
[|  0, 82, 76, 92, 59
 | 82,  0, 98, 58, 82
 | 76, 98,  0, 26, 74
 | 92, 58, 26,  0, 96
 | 59, 82, 74, 96,  0 |];

% Variables
array[CITIES, CITIES] of var 0..1: x; % x[i,j] = 1 if travel i->j
array[CITIES] of var 1..N: u;         % MTZ ordering variables
var 0..100000: total_cost;

% Constraints
constraint forall(i in CITIES) (x[i,i] = 0);

constraint forall(i in CITIES) (
  sum(j in CITIES)(x[i,j]) = 1
);

constraint forall(j in CITIES) (
  sum(i in CITIES)(x[i,j]) = 1
);

% MTZ subtour elimination
constraint u[1] = 1;
constraint forall(i in 2..N) (u[i] >= 2 /\ u[i] <= N);

constraint forall(i in 2..N, j in 2..N where i != j) (
  u[i] - u[j] + N * x[i,j] <= N - 1
);

constraint total_cost = sum(i in CITIES, j in CITIES)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;