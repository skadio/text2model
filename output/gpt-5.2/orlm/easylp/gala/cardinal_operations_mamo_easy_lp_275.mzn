% Sports team resource allocation (integer optimization)
% Minimize: 5*training + 3*equipment + 2*nutrition
% Subject to:
%  training + equipment <= 50
%  training + nutrition >= 30
%  |equipment - nutrition| <= 10
%  all variables are whole numbers (nonnegative integers)

include "globals.mzn";

% Decision variables
var 0..100: training;
var 0..100: equipment;
var 0..100: nutrition;

% Constraints
constraint training + equipment <= 50;
constraint training + nutrition >= 30;
constraint abs(equipment - nutrition) <= 10;

% Objective
var int: total_cost = 5 * training + 3 * equipment + 2 * nutrition;

solve minimize total_cost;

output [
  "training = ", show(training), "\n",
  "equipment = ", show(equipment), "\n",
  "nutrition = ", show(nutrition), "\n",
  "minimum_total_cost_score = ", show(total_cost), "\n"
];