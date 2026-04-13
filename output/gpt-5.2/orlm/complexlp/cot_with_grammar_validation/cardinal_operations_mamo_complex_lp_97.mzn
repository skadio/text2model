% Parameters
int: N = 4;
set of int: CITIES = 1..N;

array[CITIES, CITIES] of int: cost =
  [| 0, 76, 17, 24
   | 76, 0, 84, 11
   | 17, 84, 0, 90
   | 24, 11, 90, 0 |];

% Variables
array[CITIES, CITIES] of var 0..1: x;
array[CITIES] of var 0..N: u; % MTZ order variables
var 0..1000000: total_cost;

% Constraints
constraint forall(i in CITIES) (x[i,i] = 0);

constraint forall(i in CITIES) (
  sum(j in CITIES)(x[i,j]) = 1
);

constraint forall(j in CITIES) (
  sum(i in CITIES)(x[i,j]) = 1
);

% Fix a start city to remove symmetry
constraint u[1] = 1;
constraint forall(i in 2..N) (u[i] >= 2 /\ u[i] <= N);

% MTZ subtour elimination
constraint forall(i,j in 2..N where i != j) (
  u[i] - u[j] + N * x[i,j] <= N - 1
);

constraint total_cost = sum(i in CITIES, j in CITIES)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;