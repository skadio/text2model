% Parameters (with values embedded)
int: N = 5;
set of int: R = 1..N;

array[R] of int: stock = [410, 266, 132, 6, 485];
array[R] of int: need  = [274, 331, 232, 359, 74];

% cost[i,j] = cost to transfer 1 unit from region i to region j
array[R,R] of int: cost = 
[|  0, 24,  3, 27, 31
 | 24,  0, 11,  7, 37
 | 30,  1,  0, 38, 22
 | 36, 18, 17,  0, 35
 | 41, 35, 33, 33,  0 |];

% Variables
array[R,R] of var int: x; % x[i,j] units shipped from i to j

% Constraints
constraint forall(i,j in R) (
  x[i,j] >= 0
);

% No self-shipping (optional, but tightens model)
constraint forall(i in R) (
  x[i,i] = 0
);

% Flow balance: outgoing - incoming = surplus (stock - need)
constraint forall(i in R) (
  sum(j in R)(x[i,j]) - sum(j in R)(x[j,i]) = stock[i] - need[i]
);

% Objective
solve minimize sum(i,j in R)(cost[i,j] * x[i,j]);