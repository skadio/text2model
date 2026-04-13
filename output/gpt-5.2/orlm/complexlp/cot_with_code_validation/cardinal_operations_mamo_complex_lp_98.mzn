% Parameters
int: N = 4;
set of int: CITIES = 1..N;

array[CITIES, CITIES] of int: cost =
  [| 0, 26, 49, 75
   | 26, 0, 19, 52
   | 49, 19, 0, 49
   | 75, 52, 49, 0 |];

% Variables
array[CITIES, CITIES] of var 0..1: x; % x[i,j]=1 if travel from i to j
var 0..sum(i,j in CITIES where i != j)(cost[i,j]): total_cost;

% Constraints
constraint forall(i in CITIES) (x[i,i] = 0);

constraint forall(i in CITIES) (
  sum(j in CITIES)(x[i,j]) = 1
);

constraint forall(j in CITIES) (
  sum(i in CITIES)(x[i,j]) = 1
);

% Subtour elimination (MTZ)
array[CITIES] of var 1..N: u;
constraint u[1] = 1;
constraint forall(i in 2..N)(u[i] >= 2);

constraint forall(i in 2..N, j in 2..N where i != j) (
  u[i] - u[j] + N * x[i,j] <= N - 1
);

constraint total_cost = sum(i,j in CITIES)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;