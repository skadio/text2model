% Parameters
int: min_total = 20;
int: max_resource = 40;          % 2*X + Y <= 40
int: cost_x = 50;
int: cost_y = 80;

% Variables
var 0..40: x;                    % employees on Project X
var 0..40: y;                    % employees on Project Y
var 0..(cost_x*40 + cost_y*40): total_cost;

% Constraints
constraint x + y >= min_total;
constraint 2*x + y <= max_resource;
constraint total_cost = cost_x*x + cost_y*y;

% Objective
solve minimize total_cost;