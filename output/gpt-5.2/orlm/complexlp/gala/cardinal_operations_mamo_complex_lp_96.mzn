include "globals.mzn";

int: n = 6;
set of int: CITIES = 1..n;

/* Travel cost matrix (cost[i,j] = cost to go from i to j). */
array[CITIES, CITIES] of int: cost =
  [|  0, 21, 43, 25, 38, 91
   | 21,  0, 32, 25, 16, 14
   | 43, 32,  0, 96, 71, 98
   | 25, 25, 96,  0, 53, 22
   | 38, 16, 71, 53,  0,100
   | 91, 14, 98, 22,100,  0 |];

/* succ[i] is the next city after i in the tour */
array[CITIES] of var CITIES: succ;

/* Exactly one outgoing arc per city, and all successors are distinct
   => exactly one incoming arc per city as well. */
constraint all_different(succ);

/* Single Hamiltonian cycle visiting all cities exactly once */
constraint circuit(succ);

/* Objective: total travel cost along chosen successor arcs */
var int: total_cost = sum(i in CITIES)( cost[i, succ[i]] );

solve minimize total_cost;

output [
  "Minimum total travel cost = ", show(total_cost), "\n",
  "Successor representation (succ[i]=next city): ", show(succ), "\n"
];