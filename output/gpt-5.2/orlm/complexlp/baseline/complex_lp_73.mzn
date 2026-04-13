% Traveling Salesman Problem over 5 cities (E,F,G,H,I)
% Start and end in the same city, visit each city exactly once, minimize total cost.

include "globals.mzn";

int: n = 5;
set of int: CITIES = 1..n;

% City indices:
% 1=E, 2=F, 3=G, 4=H, 5=I
array[CITIES] of string: name = ["E","F","G","H","I"];

% Cost matrix (0 on diagonal; costs given are symmetric)
array[CITIES, CITIES] of int: cost =
[
  %   E   F   G   H   I
  |  0, 37, 72, 66, 33  % E
  | 37,  0, 26, 56,100  % F
  | 72, 26,  0, 49, 32  % G
  | 66, 56, 49,  0, 13  % H
  | 33,100, 32, 13,  0  % I
];

% Successor representation: succ[i] is the next city after i in the tour
array[CITIES] of var CITIES: succ;

% Enforce a single Hamiltonian cycle over all cities
constraint circuit(succ);

% Total tour cost
var int: total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "Minimum total cost: ", show(total_cost), "\n",
  "Successor mapping (city -> next):\n",
  concat([ name[i] ++ " -> " ++ name[fix(succ[i])] ++ "\n" | i in CITIES ])
];