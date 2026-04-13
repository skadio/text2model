% Parameters
int: N = 4;
set of int: CITIES = 1..N;

array[CITIES, CITIES] of int: cost =
  [|  0, 52, 89, 11
   | 52,  0, 14, 13
   | 89, 14,  0, 87
   | 11, 13, 87,  0 |];

% Variables
array[CITIES, CITIES] of var 0..1: x;   % x[i,j]=1 if travel from i to j
array[CITIES] of var 0..N: u;           % MTZ ordering variables
var 0..sum(i,j in CITIES where i != j)(cost[i,j]): total_cost;

% Constraints
constraint forall(i in CITIES)(x[i,i] = 0);

constraint forall(i in CITIES)(
  sum(j in CITIES where j != i)(x[i,j]) = 1
);

constraint forall(j in CITIES)(
  sum(i in CITIES where i != j)(x[i,j]) = 1
);

% MTZ subtour elimination (fix u[1] = 1, others in 2..N)
constraint u[1] = 1;
constraint forall(i in CITIES where i != 1)(u[i] >= 2 /\ u[i] <= N);

constraint forall(i in CITIES where i != 1, j in CITIES where j != 1 /\ j != i)(
  u[i] - u[j] + N * x[i,j] <= N - 1
);

constraint total_cost = sum(i,j in CITIES where i != j)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;