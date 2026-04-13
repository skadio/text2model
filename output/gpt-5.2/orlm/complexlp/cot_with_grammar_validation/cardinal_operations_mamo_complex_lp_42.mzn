% Parameters
int: N = 7;
set of int: W = 1..N;

array[W] of int: supply = [57, 180, 288, 255, 477, 222, 314];
array[W] of int: demand = [499, 173, 293, 158, 15, 78, 278];

array[W, W] of int: cost =
[|  0, 36, 36, 48, 10, 20, 48
 | 28,  0, 16, 18, 36, 42, 12
 |  6, 40,  0, 49, 31,  1, 46
 | 14, 22,  4,  0,  9, 12,  1
 | 50, 44,  7, 48,  0,  7, 25
 | 26,  9, 33, 38,  8,  0, 30
 |  8,  9,  2, 13,  8, 49,  0
 |];

int: totalSupply = sum(i in W)(supply[i]);
int: totalDemand = sum(i in W)(demand[i]);
int: maxFlow = totalSupply;

% Variables
array[W, W] of var 0..maxFlow: x;  % x[i,j] = units shipped from i to j
var 0..(maxFlow * max(cost)): totalCost;

% Constraints
constraint totalSupply = totalDemand;

constraint forall(i in W)(
  sum(j in W)(x[i,j]) = supply[i]
);

constraint forall(j in W)(
  sum(i in W)(x[i,j]) = demand[j]
);

constraint forall(i in W)(x[i,i] = 0);

constraint totalCost = sum(i in W, j in W)(cost[i,j] * x[i,j]);

% Objective
solve minimize totalCost;