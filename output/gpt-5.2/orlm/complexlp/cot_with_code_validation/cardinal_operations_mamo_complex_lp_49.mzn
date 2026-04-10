% Parameters
int: N = 7;
set of int: C = 1..N;

array[C] of int: supply = [97, 458, 473, 380, 34, 399, 163];
array[C] of int: demand = [119, 275, 36, 459, 17, 128, 425];

% Cost matrix (row i, column j = cost from i to j)
array[C, C] of int: cost = array2d(C, C, [
  0, 41, 42, 31, 39,  2, 18,
 48,  0,  9, 22, 47, 29, 39,
 36, 22,  0, 29, 45, 33, 45,
 19,  5, 10,  0,  3, 42, 20,
 13, 10, 21,  7,  0, 35, 11,
  5, 35, 29, 16, 40,  0,  9,
  7, 24, 26, 38, 33, 13,  0
]);

int: totalSupply = sum(i in C)(supply[i]);
int: maxCost = max(i in C, j in C)(cost[i,j]);

% Variables
array[C, C] of var 0..totalSupply: x; % x[i,j] shipped from i to j
var 0..(totalSupply * maxCost): totalCost;

% Constraints
constraint forall(i in C)(x[i,i] = 0);

% Supply limits
constraint forall(i in C)(
  sum(j in C)(x[i,j]) <= supply[i]
);

% Demand satisfaction
constraint forall(j in C)(
  sum(i in C)(x[i,j]) >= demand[j]
);

% Total cost
constraint totalCost = sum(i in C, j in C)(cost[i,j] * x[i,j]);

% Objective
solve minimize totalCost;

output [
  "totalCost = ", show(totalCost), "\n"
];