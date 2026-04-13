% Parameters (with values embedded)
int: N = 4;
set of int: CITIES = 1..N;

% City indices: 1=E, 2=F, 3=G, 4=H
array[CITIES, CITIES] of int: cost =
  [| 0, 17, 52, 79
   | 17, 0, 15, 71
   | 52, 15, 0, 54
   | 79, 71, 54, 0 |];

% Variables
array[CITIES] of var CITIES: succ;  % successor city in the tour

% Constraints
constraint circuit(succ);

% Objective
solve minimize sum(i in CITIES)(cost[i, succ[i]]);