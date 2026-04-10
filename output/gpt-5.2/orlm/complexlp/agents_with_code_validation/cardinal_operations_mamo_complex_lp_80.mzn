include "globals.mzn";

% Parameters
int: nCities = 4;
set of int: CITIES = 1..nCities;

array[CITIES, CITIES] of int: cost =
  [|  0, 17, 25, 31
   | 17,  0, 93, 45
   | 25, 93,  0, 95
   | 31, 45, 95,  0 |];

int: maxCost = max([cost[i,j] | i in CITIES, j in CITIES]);

% Variables
array[CITIES] of var CITIES: succ;                 % next city after i
var 0..(nCities * maxCost): totalCost;

% Constraints
constraint all_different(succ);                    % one incoming arc per city
constraint forall(i in CITIES) (succ[i] != i);     % no self-loops
constraint circuit(succ);                          % single Hamiltonian cycle
constraint totalCost = sum(i in CITIES) (cost[i, succ[i]]);

% Objective
solve minimize totalCost;

output [
  "totalCost = ", show(totalCost), "\n",
  "succ = ", show(succ), "\n"
];