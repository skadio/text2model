% Parameters (with values embedded)
int: max_total_hires = 10;
int: min_x = 3;
int: min_y = 2;
int: max_x = 7;
int: max_y = 8;
int: cost_x = 50000;
int: cost_y = 40000;

% Variables
var 0..max_x: x; % hires for Position X
var 0..max_y: y; % hires for Position Y
var 0..(cost_x*max_x + cost_y*max_y): total_cost;

% Constraints
constraint x >= min_x;
constraint y >= min_y;
constraint x + y <= max_total_hires;
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;