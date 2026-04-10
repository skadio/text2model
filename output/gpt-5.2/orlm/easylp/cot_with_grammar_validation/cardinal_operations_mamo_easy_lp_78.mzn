% Parameters
int: req_min = 8;              % 2*X + Y >= 8
int: budget_max = 15;          % X + 3*Y <= 15
int: cost_x = 5000;            % $ per worker on X
int: cost_y = 3000;            % $ per worker on Y

% Variables
var 0..req_min: x;             % workers on Project X
var 0..req_min: y;             % workers on Project Y
var 0..(cost_x*req_min + cost_y*req_min): total_cost;

% Constraints
constraint 2*x + y >= req_min;
constraint x + 3*y <= budget_max;

constraint total_cost = cost_x*x + cost_y*y;

% Objective
solve minimize total_cost;