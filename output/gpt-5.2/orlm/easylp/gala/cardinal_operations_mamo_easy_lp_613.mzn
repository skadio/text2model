% Crop planning as an integer linear optimization problem
% Minimize total planting cost subject to resource/ecological constraints.

include "globals.mzn";

% Decision variables: acres planted (whole numbers)
var 0..100: x1;   % Crop X1
var 0..200: x2;   % Crop X2
var 0..150: x3;   % Crop X3
var 0..120: x4;   % Crop X4

% Constraints from description
constraint 2*x1 + 3*x2 <= 50;          % fertilizer limit
constraint 4*x1 + x3 <= 40;            % water limit
constraint 5*x4 >= x2 + 10;            % soil requirement
constraint (x1 + x2) - (x3 + x4) = 0;  % ecological balance

% Objective: minimum total cost
var int: total_cost = 5*x1 + 3*x2 + 7*x3 + 6*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];