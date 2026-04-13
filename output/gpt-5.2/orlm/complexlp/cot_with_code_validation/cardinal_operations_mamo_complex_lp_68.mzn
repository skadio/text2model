include "globals.mzn";

% Parameters
int: n = 5;
set of int: Cities = 1..n;

array[Cities, Cities] of int: cost =
  [|   0, 40, 40, 56, 93
   |  40,  0, 52, 71, 90
   |  40, 52,  0, 57, 14
   |  56, 71, 57,  0, 13
   |  93, 90, 14, 13,  0 |];

% Variables: successor representation of a Hamiltonian cycle
array[Cities] of var Cities: succ;
var int: total_cost;

% Constraints
constraint forall(i in Cities)(succ[i] != i);
constraint circuit(succ);

constraint total_cost = sum(i in Cities)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];