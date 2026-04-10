% Parameters (with values embedded)
int: n = 5;
set of int: CITIES = 1..n; % 1=A, 2=B, 3=C, 4=D, 5=E

array[CITIES, CITIES] of int: cost =
  [|  0, 44, 19, 92, 71
   | 44,  0, 22, 84, 63
   | 19, 22,  0, 47, 89
   | 92, 84, 47,  0, 78
   | 71, 63, 89, 78,  0 |];

% Variables
array[CITIES] of var CITIES: succ;  % successor city in the tour
var int: total_cost;

% Constraints
constraint circuit(succ);

constraint total_cost =
  sum(i in CITIES)( cost[i, succ[i]] );

% Objective
solve minimize total_cost;