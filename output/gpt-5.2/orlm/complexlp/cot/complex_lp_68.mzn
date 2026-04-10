% Parameters (with values embedded)
int: n = 5;
set of int: Cities = 1..n;

array[Cities, Cities] of int: cost =
[|  0, 40, 40, 56, 93
 | 40,  0, 52, 71, 90
 | 40, 52,  0, 57, 14
 | 56, 71, 57,  0, 13
 | 93, 90, 14, 13,  0
 |];

% Variables
array[Cities, Cities] of var 0..1: x;          % x[i,j] = 1 if travel directly from i to j
array[Cities] of var 0..n-1: u;                % MTZ order variables
var 0..100000: total_cost;

% Constraints
constraint forall(i in Cities) (x[i,i] = 0);

% Exactly one outgoing arc from each city
constraint forall(i in Cities) (
  sum(j in Cities) x[i,j] = 1
);

% Exactly one incoming arc to each city
constraint forall(j in Cities) (
  sum(i in Cities) x[i,j] = 1
);

% MTZ subtour elimination (fix city 1 as reference)
constraint u[1] = 0;
constraint forall(i in 2..n) (u[i] >= 1 /\ u[i] <= n-1);

constraint forall(i in 2..n, j in 2..n where i != j) (
  u[i] - u[j] + (n-1) * x[i,j] <= n-2
);

% Total cost
constraint total_cost = sum(i in Cities, j in Cities) (cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;