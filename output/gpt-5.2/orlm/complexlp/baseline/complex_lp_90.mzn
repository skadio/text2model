% Traveling Salesman Problem (5 cities) - data embedded

int: n = 5;
set of int: CITIES = 1..n;

% City indices: 1=E, 2=F, 3=G, 4=H, 5=I
array[CITIES, CITIES] of int: cost =
[
  %   E   F   G   H   I
  [  0, 64, 78, 23, 15], % E
  [ 64,  0, 15, 44, 93], % F
  [ 78, 15,  0, 53, 57], % G
  [ 23, 44, 53,  0, 56], % H
  [ 15, 93, 57, 56,  0]  % I
];

% Successor representation: succ[i] is the next city after i
array[CITIES] of var CITIES: succ;

% No self-loops
constraint forall(i in CITIES)(succ[i] != i);

% Enforce a single Hamiltonian cycle visiting each city exactly once
include "globals.mzn";
constraint circuit(succ);

var int: total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "Minimum total delivery cost = ", show(total_cost), "\n",
  "Successor mapping (1=E,2=F,3=G,4=H,5=I):\n",
  concat([ show(i) ++ "->" ++ show(succ[i]) ++ "\n" | i in CITIES ])
];