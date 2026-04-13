include "globals.mzn";

int: n = 4;
set of int: CITIES = 1..n;

% Travel cost matrix (diagonal entries unused; set to 0)
array[CITIES, CITIES] of int: cost =
  [|  0, 76, 17, 24
   | 76,  0, 84, 11
   | 17, 84,  0, 90
   | 24, 11, 90,  0 |];

% next[i] = city visited immediately after city i
array[CITIES] of var CITIES: next;

% Prevent self-loops and ensure each city has exactly one incoming arc
constraint forall(i in CITIES)(next[i] != i);
constraint all_different(next);

% Eliminate subtours: ensure a single Hamiltonian cycle
constraint circuit(next);

var int: total_cost = sum(i in CITIES)(cost[i, next[i]]);

solve minimize total_cost;

output [
  "next = ", show(next), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];