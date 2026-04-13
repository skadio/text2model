% Parameters
int: max_weighted_acres = 50;
int: cost_X = 100;
int: cost_Y = 200;
int: min_diff_XY = 10;

% Variables
var 0..max_weighted_acres: x; % acres of crop X
var 0..max_weighted_acres: y; % acres of crop Y
var 0..(cost_X*max_weighted_acres + cost_Y*max_weighted_acres): total_cost;

% Constraints
constraint 2*x + 3*y <= max_weighted_acres;
constraint x >= y + min_diff_XY;

constraint total_cost = cost_X*x + cost_Y*y;

% Objective
solve minimize total_cost;