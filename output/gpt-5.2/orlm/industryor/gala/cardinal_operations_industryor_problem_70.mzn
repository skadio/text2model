include "globals.mzn";

% Problem data (embedded)
int: n = 2;

% Transportation volumes between factories i -> j (from table: row i, column j)
array[1..n, 1..n] of int: d =
  array2d(1..n, 1..n, [
    10, 20,
    30, 40
  ]);

% Unit transportation costs between locations p -> q (from table: row p, column q)
array[1..n, 1..n] of int: c =
  array2d(1..n, 1..n, [
    5, 8,
    6, 7
  ]);

% Decision variables:
% loc_of_factory[i] = location assigned to factory i (a permutation of 1..n)
array[1..n] of var 1..n: loc_of_factory;

% Bijection constraint (each location hosts exactly one factory)
constraint all_different(loc_of_factory);

% Objective: sum over all ordered pairs (i,j) of volume d[i,j] * cost between their assigned locations
var int: total_cost =
  sum(i in 1..n, j in 1..n)(
    d[i,j] * c[ loc_of_factory[i], loc_of_factory[j] ]
  );

solve minimize total_cost;

output [
  "loc_of_factory = ", show(loc_of_factory), "\n",
  "total_cost = ", show(total_cost), "\n"
];