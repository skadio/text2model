% Parameters
int: cost_x = 4;
int: cost_y = 5;
int: max_combined = 100;          % x + 2y <= 100
int: min_requirement = 50;        % 3x - y >= 50

% Variables
var 0..max_combined: x;           % allocation to Project X
var 0..max_combined: y;           % allocation to Project Y
var 0..(cost_x*max_combined + cost_y*max_combined): total_cost;

% Constraints
constraint x + 2*y <= max_combined;
constraint 3*x - y >= min_requirement;

constraint total_cost = cost_x*x + cost_y*y;

% Objective
solve minimize total_cost;