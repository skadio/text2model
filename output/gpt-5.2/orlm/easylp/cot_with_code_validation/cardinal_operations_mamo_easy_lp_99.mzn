% Parameters
int: max_hires = 50;
int: cost_x = 5000;
int: cost_y = 8000;

% Variables
var 0..max_hires: X;
var 0..max_hires: Y;
var 0..(cost_x * max_hires + cost_y * max_hires): total_cost;

% Constraints
constraint X + Y <= max_hires;
constraint X >= 3 * (max_hires - Y);
constraint total_cost = cost_x * X + cost_y * Y;

% Objective
solve minimize total_cost;