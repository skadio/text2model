include "globals.mzn";

% Parameters
int: nCities = 5;
set of int: CITIES = 1..nCities;  % 1=E, 2=F, 3=G, 4=H, 5=I

% Cost matrix (diagonal 0)
array[CITIES, CITIES] of int: cost =
  [|  0, 64, 78, 23, 15
   | 64,  0, 15, 44, 93
   | 78, 15,  0, 53, 57
   | 23, 44, 53,  0, 56
   | 15, 93, 57, 56,  0
  |];

% Variables
array[CITIES] of var CITIES: succ;  % succ[i] = next city after i
var 0..sum(i in CITIES, j in CITIES)(cost[i,j]): totalCost;

% Constraints
constraint forall(i in CITIES) (succ[i] != i);         % no self loops
constraint all_different(succ);                        % each city has exactly one successor
constraint circuit(succ);                              % single Hamiltonian cycle (also enforces predecessors)

constraint totalCost = sum(i in CITIES)(cost[i, succ[i]]);

% Objective
solve minimize totalCost;

output ["totalCost = ", show(totalCost), "\n",
        "succ = ", show(succ), "\n"];