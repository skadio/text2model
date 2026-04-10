% Logistics vehicle planning (integer linear optimization)
% Embed all data directly as requested.

include "globals.mzn";

% Data
int: minVehicles = 10;
int: cap = 25;
int: costX = 5;
int: costY = 7;

% Decision variables (whole numbers of vehicles)
var 0..cap: x;  % number of type X vehicles
var 0..cap: y;  % number of type Y vehicles

% Constraints
constraint x + y >= minVehicles;
constraint 2*x + 3*y <= cap;

% Objective: minimize total cost
var int: totalCost = costX*x + costY*y;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = ", show(totalCost), "\n"
];