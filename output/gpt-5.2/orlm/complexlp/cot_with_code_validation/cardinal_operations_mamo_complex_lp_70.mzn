include "globals.mzn";

% Parameters
int: N = 4;
set of int: Cities = 1..N;

array[Cities, Cities] of int: cost =
  array2d(Cities, Cities,
  [  0, 61, 17, 81,
    61,  0, 40, 52,
    17, 40,  0, 23,
    81, 52, 23,  0 ]);

% Variables
array[Cities] of var Cities: succ;
var int: total_cost;

% Constraints
constraint forall(i in Cities) (succ[i] != i);

% succ forms a single Hamiltonian cycle over all cities
constraint circuit(succ);

constraint total_cost = sum(i in Cities)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];