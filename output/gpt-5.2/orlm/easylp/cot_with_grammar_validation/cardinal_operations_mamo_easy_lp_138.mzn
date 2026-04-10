% Parameters
int: min_total_units = 100;
int: max_strength = 600;
int: strength_x = 5;
int: strength_y = 3;
int: cost_x = 5000;
int: cost_y = 3000;

% Variables
var 0..max_strength div strength_x: x;
var 0..max_strength div strength_y: y;
var 0..(cost_x * (max_strength div strength_x) + cost_y * (max_strength div strength_y)): total_cost;

% Constraints
constraint x + y >= min_total_units;
constraint strength_x * x + strength_y * y <= max_strength;
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;