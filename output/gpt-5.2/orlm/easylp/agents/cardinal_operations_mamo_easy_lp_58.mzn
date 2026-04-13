% Parameters
int: max_total_units = 100;          % Total shelf capacity for X + Y
int: min_diversity = 50;             % Minimum required value for 2*X + Y
int: profit_x = 5;                   % Profit per unit of product X
int: profit_y = 3;                   % Profit per unit of product Y
int: max_x = 60;                     % Maximum boxes/units of product X
int: max_y = 70;                     % Maximum boxes/units of product Y

% Variables
var 0..max_x: x_units;               % Number of units (boxes) of product X
var 0..max_y: y_units;               % Number of units (boxes) of product Y
var 0..(profit_x*max_x + profit_y*max_y): total_profit; % Total profit (objective)

% Constraints
% Shelf capacity constraint: total units cannot exceed available shelf space
constraint x_units + y_units <= max_total_units;

% Diversity constraint: ensure a minimum combined offering (2*X + Y at least min_diversity)
constraint 2 * x_units + y_units >= min_diversity;

% Profit definition: total profit equals profit from X plus profit from Y
constraint total_profit = profit_x * x_units + profit_y * y_units;

% Objective
solve maximize total_profit;