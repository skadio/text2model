% Truck allocation between two routes with linear constraints and cost minimization.
% All data embedded as requested.

include "globals.mzn";

% Decision variables: number of trucks on routes X and Y (whole numbers)
var 0..1000: x; % trucks on route X
var 0..1000: y; % trucks on route Y

% Constraints
constraint 2*x + 3*y <= 500;        % highway weight restriction
constraint x + y >= 100;            % demand requirement
constraint abs(x - y) <= 50;        % balance requirement

% Objective: minimize total cost
var int: total_cost = 4*x + 6*y;
solve minimize total_cost;

% Output (rounded to nearest whole number: objective is already integer)
output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "min_total_cost = ", show(total_cost), "\n"
];