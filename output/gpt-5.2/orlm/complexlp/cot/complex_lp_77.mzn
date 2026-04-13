% Parameters (with values embedded)
int: n = 4;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
  [| 0, 27, 48, 76
   | 27, 0, 82, 88
   | 48, 82, 0, 97
   | 76, 88, 97, 0 |];

% Variables
array[CITIES] of var CITIES: succ;  % successor city in the tour
var 0..sum(i in CITIES, j in CITIES)(cost[i,j]): total_cost;

% Constraints
constraint circuit(succ);

constraint total_cost = sum(i in CITIES)( cost[i, succ[i]] );

% Objective
solve minimize total_cost;