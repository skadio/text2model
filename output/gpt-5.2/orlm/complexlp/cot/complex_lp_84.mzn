% Parameters (with values embedded)
include "globals.mzn";

int: n = 6;
set of int: Cities = 1..n;

array[Cities, Cities] of int: cost =
[|  0, 23, 50, 92, 56, 91
 | 23,  0, 38, 25, 25, 69
 | 50, 38,  0, 66, 51, 76
 | 92, 25, 66,  0, 97, 37
 | 56, 25, 51, 97,  0, 30
 | 91, 69, 76, 37, 30,  0 |];

% Variables
array[Cities, Cities] of var 0..1: x;         % x[i,j]=1 if travel directly from i to j
array[Cities] of var 0..n: u;                 % MTZ order variables
var 0..1000000: total_cost;

% Constraints
constraint forall(i in Cities)(x[i,i] = 0);

% Exactly one outgoing arc from each city
constraint forall(i in Cities)(
  sum(j in Cities)(x[i,j]) = 1
);

% Exactly one incoming arc to each city
constraint forall(j in Cities)(
  sum(i in Cities)(x[i,j]) = 1
);

% MTZ subtour elimination (fix u[1] = 1 to break symmetry)
constraint u[1] = 1;
constraint forall(i in Cities where i != 1)(u[i] >= 2 /\ u[i] <= n);

constraint forall(i in Cities where i != 1)(
  forall(j in Cities where j != 1 /\ j != i)(
    u[i] - u[j] + n * x[i,j] <= n - 1
  )
);

% Total cost definition
constraint total_cost = sum(i in Cities, j in Cities)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;