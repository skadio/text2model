% Parameters
int: n = 4;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
  array2d(CITIES, CITIES, [
    0,  27, 48, 76,
    27, 0,  82, 88,
    48, 82, 0,  97,
    76, 88, 97, 0
  ]);

% Variables
array[CITIES, CITIES] of var 0..1: x;          % x[i,j] = 1 if go from i to j
array[CITIES] of var 1..n: u;                  % MTZ ordering variables
var 0..sum(i in CITIES, j in CITIES)(cost[i,j]): total_cost;

% Constraints
constraint forall(i in CITIES)(x[i,i] = 0);

constraint forall(i in CITIES)(
  sum(j in CITIES)(x[i,j]) = 1
);

constraint forall(j in CITIES)(
  sum(i in CITIES)(x[i,j]) = 1
);

% MTZ subtour elimination (fix u[1] = 1, others in 2..n)
constraint u[1] = 1;
constraint forall(i in 2..n)(u[i] >= 2 /\ u[i] <= n);

constraint forall(i in 2..n, j in 2..n where i != j)(
  u[i] - u[j] + n * x[i,j] <= n - 1
);

constraint total_cost = sum(i in CITIES, j in CITIES)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;