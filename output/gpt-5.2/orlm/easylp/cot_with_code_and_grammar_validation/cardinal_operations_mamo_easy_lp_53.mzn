% Parameters
int: min_demand = 50;
int: max_overstock = 150;

int: profit_x = 10;
int: profit_y = 5;

% Variables
var 0..max_overstock: x;
var 0..max_overstock: y;

% Constraints
constraint 2*x + y >= min_demand;
constraint x + 3*y <= max_overstock;

% Objective
solve maximize profit_x * x + profit_y * y;