% Parameters
int: min_total_time = 15;
int: max_weighted_time = 40; % 2*x + y <= 40
int: cost_x = 20;
int: cost_y = 30;

% Variables
var 0..max_weighted_time: x; % hours for exercise X
var 0..max_weighted_time: y; % hours for exercise Y
var 0..(cost_x*max_weighted_time + cost_y*max_weighted_time): total_cost;

% Constraints
constraint x + y >= min_total_time;
constraint 2*x + y <= max_weighted_time;
constraint total_cost = cost_x*x + cost_y*y;

% Objective
solve minimize total_cost;