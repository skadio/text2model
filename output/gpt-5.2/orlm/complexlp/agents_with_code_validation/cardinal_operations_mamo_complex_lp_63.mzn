include "globals.mzn";

% Parameters
int: nCities = 5;
set of int: Cities = 1..nCities;

% Travel cost matrix (cost[i,j] = cost to go from i to j)
array[Cities, Cities] of int: cost =
array2d(Cities, Cities, [
   0, 28, 89, 59, 41,
  28,  0, 85, 12, 68,
  89, 85,  0, 22, 70,
  59, 12, 22,  0, 48,
  41, 68, 70, 48,  0
]);

% Useful bounds for objective
int: maxArcCost = max([cost[i,j] | i in Cities, j in Cities]);
int: maxTotalCost = nCities * maxArcCost;

% Variables
array[Cities] of var Cities: succ;        % succ[i] = next city visited after i
array[Cities] of var Cities: pred;        % pred[i] = previous city visited before i
var 0..maxTotalCost: totalCost;           % Total tour cost

% Constraints
constraint forall(i in Cities) (succ[i] != i);
constraint forall(i in Cities) (pred[i] != i);

constraint inverse(succ, pred);
constraint circuit(succ);

constraint totalCost = sum(i in Cities)(cost[i, succ[i]]);

solve minimize totalCost;

output [
  "totalCost = ", show(totalCost), "\n",
  "succ = ", show(succ), "\n"
];