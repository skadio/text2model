% Crop planting cost minimization
% Data embedded as required (no .dzn).

include "globals.mzn";

% Costs ($ per bag/acre)
int: costCorn = 50;
int: costWheat = 30;
int: costSoy  = 20;

% Decision variables: whole bags (acres)
var 0..100000: Corn;
var 0..100000: Wheat;
var 0..100000: Soybean;

% Constraints
% Food security: 2*Corn + Wheat >= 1000
constraint 2 * Corn + Wheat >= 1000;

% Soil health: Wheat + Soybean <= 5000
constraint Wheat + Soybean <= 5000;

% Market demand: Corn >= Soybean + 1000
constraint Corn >= Soybean + 1000;

% Objective: minimize total cost
var int: TotalCost = costCorn * Corn + costWheat * Wheat + costSoy * Soybean;

solve minimize TotalCost;

output [
  "Corn = ", show(Corn), "\n",
  "Wheat = ", show(Wheat), "\n",
  "Soybean = ", show(Soybean), "\n",
  "Minimum cost ($) = ", show(TotalCost), "\n"
];