include "globals.mzn";

% Parameters
int: n = 4;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: dist =
  [| 0, 10, 20, 12
   | 10, 0,  5, 10
   | 20, 5,  0,  8
   | 15, 12, 8,  0 |];

% Variables
array[CITIES] of var CITIES: succ;   % successor city in the tour
var int: total_distance;

% Constraints: single Hamiltonian circuit
constraint circuit(succ);

% Symmetry breaking: fix successor of city 1
constraint succ[1] < succ[n];

% Total distance
constraint total_distance = sum(i in CITIES)(dist[i, succ[i]]);

% Objective
solve minimize total_distance;

output [
  "total_distance = ", show(total_distance), "\n",
  "succ = ", show(succ), "\n"
];