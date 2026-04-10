% Parameters (with values embedded)
int: n = 6;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
  [|  0, 49, 34, 18, 62, 14
   | 49,  0, 35, 24, 57, 17
   | 34, 35,  0, 20, 34, 58
   | 18, 24, 20,  0, 47, 45
   | 62, 57, 34, 47,  0, 71
   | 14, 17, 58, 45, 71,  0 |];

% Variables
array[CITIES, CITIES] of var 0..1: x; % x[i,j]=1 if travel directly from i to j
array[CITIES] of var 0..n-1: u;       % MTZ order variables
var 0..1000000: total_cost;

% Constraints
constraint forall(i in CITIES) (x[i,i] = 0);

constraint forall(i in CITIES) (
  sum(j in CITIES)(x[i,j]) = 1
);

constraint forall(j in CITIES) (
  sum(i in CITIES)(x[i,j]) = 1
);

% Fix start city to 1 for symmetry breaking (tour cost unchanged)
constraint u[1] = 0;
constraint forall(i in 2..n) (u[i] >= 1 /\ u[i] <= n-1);

% MTZ subtour elimination
constraint forall(i in 2..n, j in 2..n where i != j) (
  u[i] - u[j] + (n-1) * x[i,j] <= n-2
);

constraint total_cost = sum(i in CITIES, j in CITIES)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;