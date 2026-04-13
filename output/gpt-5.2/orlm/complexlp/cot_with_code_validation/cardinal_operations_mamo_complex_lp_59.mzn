include "globals.mzn";

% Parameters
int: n = 5;
set of int: CITIES = 1..n;

% City mapping (for readability in comments):
% 1=E, 2=F, 3=G, 4=H, 5=I

array[CITIES, CITIES] of int: cost = array2d(CITIES, CITIES, [
  %   E   F   G   H   I
      0, 50, 48, 99, 91,   % E
     50,  0, 57, 84, 72,   % F
     48, 57,  0, 46, 86,   % G
     99, 84, 46,  0, 29,   % H
     91, 72, 86, 29,  0    % I
]);

int: maxCost = max([cost[i,j] | i,j in CITIES]);
int: UB = n * maxCost;

% Variables
array[CITIES] of var CITIES: succ;   % successor city for each city
var 0..UB: totalCost;

% Constraints (Hamiltonian cycle)
constraint forall(i in CITIES)(succ[i] != i);
constraint circuit(succ);

constraint totalCost = sum(i in CITIES)(cost[i, succ[i]]);

% Objective
solve minimize totalCost;

output [
  "totalCost = ", show(totalCost), "\n",
  "succ = ", show(succ), "\n"
];