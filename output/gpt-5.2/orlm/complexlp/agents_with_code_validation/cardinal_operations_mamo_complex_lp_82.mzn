include "globals.mzn";

% Parameters
int: nCities = 4;
set of int: CITIES = 1..nCities;  % 1=Alpha, 2=Bravo, 3=Charlie, 4=Delta

array[CITIES, CITIES] of int: cost =
  [|  0, 41, 55, 22
   | 41,  0, 47, 47
   | 55, 47,  0, 35
   | 22, 47, 35,  0 |];

% Variables
array[CITIES] of var CITIES: next;   % successor city
var int: total_cost;

% Constraints: Hamiltonian cycle visiting each city exactly once
constraint circuit(next);

% Total tour cost
constraint total_cost = sum(i in CITIES)(cost[i, next[i]]);

% Objective
solve minimize total_cost;

output [
  "Minimum total delivery cost = ", show(total_cost), "\n",
  "Successor mapping (city -> next city): ", show(next), "\n"
];