include "globals.mzn";

% Parameters
int: n = 4;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
  [|  0, 41, 55, 22
   | 41,  0, 47, 47
   | 55, 47,  0, 35
   | 22, 47, 35,  0 |];

int: start = 1; % symmetry breaking: fix a reference city

% Variables
array[CITIES] of var CITIES: succ;   % successor city in the tour
var int: total_cost;

% Constraints
constraint circuit(succ);
constraint succ[start] != start; % avoid trivial self-loop on the reference city (redundant with circuit)

constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];