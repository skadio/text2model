% Parameters
int: max_total_units = 100;          % Total shelf capacity for X and Y combined
int: min_diversity_requirement = 50; % Minimum required value for 2*X + Y
int: profit_x = 5;                   % Profit per unit (box) of product X
int: profit_y = 3;                   % Profit per unit (box) of product Y
int: max_x = 60;                     % Maximum allowable boxes of product X
int: max_y = 70;                     % Maximum allowable boxes of product Y

% Variables
var 0..max_x: x_units;               % Number of boxes of product X
var 0..max_y: y_units;               % Number of boxes of product Y
var 0..(profit_x*max_x + profit_y*max_y): total_profit; % Total profit in dollars

% Constraints
% Shelf capacity constraint: total units of X and Y cannot exceed available space
constraint x_units + y_units <= max_total_units;

% Diversity requirement constraint: ensure enough combined variety (2*X + Y >= threshold)
constraint 2 * x_units + y_units >= min_diversity_requirement;

% Total profit definition: link total_profit to chosen quantities
constraint total_profit = profit_x * x_units + profit_y * y_units;

% Objective
solve maximize total_profit;

% Optional output (kept minimal, but useful)
output [
  "x_units = ", show(x_units), "\n",
  "y_units = ", show(y_units), "\n",
  "total_profit = $", show(total_profit), "\n"
];