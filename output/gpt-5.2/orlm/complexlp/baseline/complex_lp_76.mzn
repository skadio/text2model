% Traveling Salesman Problem (5 cities) with embedded data

int: n = 5;
set of int: CITIES = 1..n;

% City indices: 1=E, 2=F, 3=G, 4=H, 5=I
array[CITIES, CITIES] of int: cost = array2d(CITIES, CITIES, [
  0, 31, 19, 71, 74,
  31, 0, 39, 77, 84,
  19, 39, 0, 65, 78,
  71, 77, 65, 0, 38,
  74, 84, 78, 38, 0
]);

% Successor representation of a Hamiltonian cycle:
% succ[i] is the next city visited after i
array[CITIES] of var CITIES: succ;

% Prevent self-loops
constraint forall(i in CITIES)(succ[i] != i);

% Ensure it's a single tour visiting all cities exactly once
include "globals.mzn";
constraint circuit(succ);

var int: total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

array[CITIES] of string: name = ["E","F","G","H","I"];

output [
  "Minimum total delivery cost = ", show(total_cost), "\n",
  "Successor mapping (city -> next):\n"
] ++
[
  name[i] ++ " -> " ++ name[fix(succ[i])] ++ "\n"
  | i in CITIES
];