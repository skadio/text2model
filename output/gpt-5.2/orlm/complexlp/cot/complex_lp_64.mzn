% Parameters (with values embedded)
int: N = 6;
set of int: CITIES = 1..N;

array[CITIES, CITIES] of int: cost =
  [|  0, 65, 41, 14, 16, 35
   | 65,  0, 76, 52, 89, 45
   | 41, 76,  0, 72, 38, 62
   | 14, 52, 72,  0, 22, 24
   | 16, 89, 38, 22,  0, 89
   | 35, 45, 62, 24, 89,  0 |];

% Variables
array[CITIES] of var CITIES: succ;  % successor city in the tour
var 0..100000: total_cost;

% Constraints
constraint circuit(succ);

constraint total_cost =
  sum(i in CITIES)( cost[i, succ[i]] );

% Objective
solve minimize total_cost;