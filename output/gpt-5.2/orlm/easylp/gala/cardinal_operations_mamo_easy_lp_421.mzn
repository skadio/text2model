include "globals.mzn";

% Data (embedded as required)
int: max_total_units = 5000;
int: min_x_units = 1000;
int: min_y_units = 1500;

int: cost_per_unit_x = 100;   % dollars per unit
int: cost_per_unit_y = 75;    % dollars per unit

% Decision variables: whole-number resource units allocated to each project
var min_x_units..max_total_units: x;
var min_y_units..max_total_units: y;

% Constraints
constraint x + y <= max_total_units;

% Objective: minimize total cost
var int: total_cost = cost_per_unit_x * x + cost_per_unit_y * y;

solve minimize total_cost;

output [
  "x_units = ", show(x), "\n",
  "y_units = ", show(y), "\n",
  "total_cost = $", show(total_cost), "\n"
];