% Parameters (with values embedded)
int: N = 4;
set of int: CITIES = 1..N;

array[CITIES, CITIES] of int: cost =
  [| 0, 26, 49, 75
   | 26, 0, 19, 52
   | 49, 19, 0, 49
   | 75, 52, 49, 0 |];

% Variables
array[CITIES, CITIES] of var 0..1: x;              % x[i,j] = 1 if travel i->j
array[CITIES] of var 1..N: u;                      % MTZ order variables
var 0..10000: total_cost;

% Constraints
constraint forall(i in CITIES) (x[i,i] = 0);

% Exactly one outgoing arc from each city
constraint forall(i in CITIES) (
  sum(j in CITIES) (x[i,j]) = 1
);

% Exactly one incoming arc to each city
constraint forall(j in CITIES) (
  sum(i in CITIES) (x[i,j]) = 1
);

% MTZ subtour elimination (fix city 1 as start)
constraint u[1] = 1;
constraint forall(i in 2..N) (u[i] >= 2 /\ u[i] <= N);

constraint forall(i in 2..N, j in 2..N where i != j) (
  u[i] - u[j] + N * x[i,j] <= N - 1
);

% Total cost
constraint total_cost = sum(i in CITIES, j in CITIES) (cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;