% Parameters
int: inv_min = 10;          % x + 3y >= 10
int: storage_max = 15;      % 2x + y <= 15
int: cost_x = 4;
int: cost_y = 5;

% Variables
var 0..storage_max: x;
var 0..storage_max: y;
var 0..(cost_x*storage_max + cost_y*storage_max): total_cost;

% Constraints
constraint x + 3*y >= inv_min;
constraint 2*x + y <= storage_max;
constraint total_cost = cost_x*x + cost_y*y;

% Objective
solve minimize total_cost;