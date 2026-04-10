% Parameters (with values embedded)
int: N = 5;
set of int: CITIES = 1..N;

array[CITIES, CITIES] of int: cost =
  [| 0, 28, 89, 59, 41
   | 28, 0, 85, 12, 68
   | 89, 85, 0, 22, 70
   | 59, 12, 22, 0, 48
   | 41, 68, 70, 48, 0 |];

% Variables
array[CITIES] of var CITIES: succ;
array[CITIES] of var CITIES: pos;
var 0..100000: total_cost;

% Constraints
constraint forall(i in CITIES)(succ[i] != i);
constraint all_different(succ);

% Circuit (single Hamiltonian cycle; starting city can be any)
constraint circuit(succ);

% Total cost
constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;