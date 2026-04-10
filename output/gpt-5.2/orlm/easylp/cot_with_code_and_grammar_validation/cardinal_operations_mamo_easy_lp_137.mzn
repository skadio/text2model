% Parameters
int: max_total = 100;
int: min_total = 30;

int: eff_x = 2;
int: eff_y = 3;
int: min_eff = 150;

int: cost_x = 4;
int: cost_y = 5;

% Variables
var 0..max_total: x;
var 0..max_total: y;
var 0..(cost_x * max_total + cost_y * max_total): total_cost;

% Constraints
constraint x + y <= max_total;
constraint x + y >= min_total;

constraint eff_x * x + eff_y * y >= min_eff;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;