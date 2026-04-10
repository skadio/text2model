% Parameters
int: n = 4;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
  [|  0, 94, 34, 87
   | 94,  0, 62, 87
   | 34, 62,  0, 97
   | 87, 87, 97,  0 |];

% Variables
array[CITIES, CITIES] of var 0..1: x;   % x[i,j] = 1 if travel from i to j
array[CITIES] of var 1..n: u;            % MTZ ordering variables

var int: total_cost;

% Constraints
constraint forall(i in CITIES)(x[i,i] = 0);

constraint forall(i in CITIES)(
  sum(j in CITIES)(x[i,j]) = 1
);

constraint forall(j in CITIES)(
  sum(i in CITIES)(x[i,j]) = 1
);

% MTZ subtour elimination (fix city 1 as start/reference)
constraint u[1] = 1;
constraint forall(i in 2..n)(u[i] >= 2 /\ u[i] <= n);

constraint forall(i in 2..n, j in 2..n where i != j)(
  u[i] - u[j] + n * x[i,j] <= n - 1
);

constraint total_cost = sum(i in CITIES, j in CITIES)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;