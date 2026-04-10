% Parameters
int: n = 4;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
[|  0, 76, 17, 24
 | 76,  0, 84, 11
 | 17, 84,  0, 90
 | 24, 11, 90,  0
 |];

% Variables
array[CITIES, CITIES] of var 0..1: x;          % x[i,j] = 1 if tour goes from i to j
array[CITIES] of var 0..n-1: u;                % MTZ order variables
var int: total_cost;

% Constraints
constraint forall(i in CITIES) (x[i,i] = 0);

% Exactly one outgoing arc from each city
constraint forall(i in CITIES) (
  sum(j in CITIES)(x[i,j]) = 1
);

% Exactly one incoming arc to each city
constraint forall(j in CITIES) (
  sum(i in CITIES)(x[i,j]) = 1
);

% MTZ subtour elimination (fix city 1 as reference)
constraint u[1] = 0;
constraint forall(i in 2..n) (u[i] >= 1 /\ u[i] <= n-1);

constraint forall(i in 2..n, j in 2..n where i != j) (
  u[i] - u[j] + (n-1) * x[i,j] <= n-2
);

% Total cost
constraint total_cost = sum(i in CITIES, j in CITIES)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;