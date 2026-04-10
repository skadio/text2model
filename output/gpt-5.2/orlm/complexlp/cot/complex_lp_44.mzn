% Parameters (with values embedded)
int: N = 7;
set of int: R = 1..N;

array[R] of int: supply = [318, 349, 129, 381, 430, 52, 124];
array[R] of int: demand = [309, 9, 279, 71, 365, 233, 483];

array[R, R] of int: cost =
  [|  0,  2, 26, 19, 16, 26, 36
   | 27,  0, 26,  4, 15, 43, 25
   | 17, 45,  0, 18, 36, 37, 39
   | 19, 16, 14,  0,  5, 35,  9
   | 44, 47,  4,  3,  0,  2,  4
   | 30, 12, 28, 10, 16,  0, 25
   | 19, 16, 10,  2, 50,  4,  0 |];

int: totalSupply = sum(r in R)(supply[r]);
int: totalDemand = sum(r in R)(demand[r]);

% Variables
% x[i,j] = units shipped from region i to region j
array[R, R] of var 0..totalSupply: x;

% Constraints
constraint totalSupply >= totalDemand;

% No self-shipments needed
constraint forall(i in R)(x[i,i] = 0);

% Supply limits: cannot ship more than available at origin
constraint forall(i in R)(
  sum(j in R)(x[i,j]) <= supply[i]
);

% Demand satisfaction: initial + inflow - outflow >= demand
constraint forall(r in R)(
  supply[r] + sum(i in R)(x[i,r]) - sum(j in R)(x[r,j]) >= demand[r]
);

% Objective
var int: totalCost = sum(i in R, j in R)(cost[i,j] * x[i,j]);
solve minimize totalCost;