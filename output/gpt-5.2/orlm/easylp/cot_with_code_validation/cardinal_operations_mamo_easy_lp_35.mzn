% Parameters
int: min_total = 50000;
int: max_diff  = 20000;
int: cost_stock = 4;
int: cost_bond  = 3;

% Variables
% x = number of stock units, y = number of bond units (whole numbers)
var 0..12500: x; % from 4*x + 3*y >= 50000 => x <= 12500 when y=0
var 0..16666: y; % from 4*x + 3*y >= 50000 => y <= 16666 when x=0

% Constraints
constraint 2*x + y >= min_total;
constraint x - 2*y <= max_diff;

% Objective
solve minimize cost_stock*x + cost_bond*y;