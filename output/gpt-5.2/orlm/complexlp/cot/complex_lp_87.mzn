% Parameters (with values embedded)
int: n = 5;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
[|  0, 46, 63, 54, 45
 | 46,  0, 48, 50, 51
 | 63, 48,  0, 31, 64
 | 54, 50, 31,  0, 94
 | 45, 51, 64, 94,  0 |];

% Variables
array[CITIES] of var CITIES: succ;  % successor city in the tour
var int: total_cost;

% Constraints
constraint circuit(succ);

constraint total_cost =
  sum(i in CITIES)( cost[i, succ[i]] );

% Objective
solve minimize total_cost;

output [
  "Minimum total travel cost = ", show(total_cost), "\n",
  "Successor mapping (city -> next city): ", show(succ), "\n"
];