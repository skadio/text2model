include "globals.mzn";

int: n = 6;
set of int: Cities = 1..n;

array[Cities, Cities] of int: cost =
[
  % to:   1   2   3   4   5   6
  /*1*/ [  0, 49, 34, 18, 62, 14],
  /*2*/ [ 49,  0, 35, 24, 57, 17],
  /*3*/ [ 34, 35,  0, 20, 34, 58],
  /*4*/ [ 18, 24, 20,  0, 47, 45],
  /*5*/ [ 62, 57, 34, 47,  0, 71],
  /*6*/ [ 14, 17, 58, 45, 71,  0]
];

% Successor representation of a Hamiltonian cycle
array[Cities] of var Cities: succ;

constraint circuit(succ);

var int: total_cost = sum(i in Cities)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "Minimum total travel cost = ", show(total_cost), "\n",
  "Successor array (next city from i): ", show(succ), "\n"
];