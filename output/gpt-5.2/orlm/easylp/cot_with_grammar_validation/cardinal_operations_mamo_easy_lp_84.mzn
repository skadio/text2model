% Parameters
int: max_hours = 40;
int: min_output = 20;
int: cost_x = 8;
int: cost_y = 6;

% Variables
var 0..max_hours: X;
var 0..max_hours: Y;
var 0..(cost_x*max_hours + cost_y*max_hours): total_cost;

% Constraints
constraint X + Y <= max_hours;
constraint 2*X + Y >= min_output;
constraint total_cost = cost_x*X + cost_y*Y;

% Objective
solve minimize total_cost;