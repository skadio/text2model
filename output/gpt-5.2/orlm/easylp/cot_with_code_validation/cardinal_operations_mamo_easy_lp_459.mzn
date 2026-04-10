% Parameters
int: min_total_hours = 50;
int: max_weighted_hours = 120; % 2*X + Y <= 120
int: cost_x = 8;
int: cost_y = 10;

% Variables
var 0..max_weighted_hours: x; % hours for task X
var 0..max_weighted_hours: y; % hours for task Y
var 0..(cost_x*max_weighted_hours + cost_y*max_weighted_hours): total_cost;

% Constraints
constraint x + y >= min_total_hours;
constraint 2*x + y <= max_weighted_hours;
constraint x >= y;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;