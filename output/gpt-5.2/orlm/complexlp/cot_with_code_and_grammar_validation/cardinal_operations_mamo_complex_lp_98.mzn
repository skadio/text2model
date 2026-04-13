% Parameters
int: n = 4;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
  [|  0, 26, 49, 75
   | 26,  0, 19, 52
   | 49, 19,  0, 49
   | 75, 52, 49,  0 |];

% Variables
array[CITIES, CITIES] of var 0..1: x;
array[CITIES] of var 0..n-1: u; % MTZ order variables (for subtour elimination)
var 0..sum(i in CITIES, j in CITIES)(cost[i,j]): total_cost;

% Constraints
constraint forall(i in CITIES) (
  sum(j in CITIES where j != i) (x[i,j]) = 1
);

constraint forall(j in CITIES) (
  sum(i in CITIES where i != j) (x[i,j]) = 1
);

constraint forall(i in CITIES) (x[i,i] = 0);

% Fix a start city to break symmetry (City 1)
constraint u[1] = 0;
constraint forall(i in 2..n) (u[i] >= 1 /\ u[i] <= n-1);

% MTZ subtour elimination
constraint forall(i in 2..n, j in 2..n where i != j) (
  u[i] - u[j] + n * x[i,j] <= n - 1
);

constraint total_cost = sum(i in CITIES, j in CITIES)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;