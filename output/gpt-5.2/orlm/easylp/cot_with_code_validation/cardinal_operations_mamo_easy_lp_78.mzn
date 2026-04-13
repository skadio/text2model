% Parameters
int: min_req = 8;          % 2*X + Y >= 8
int: max_budget = 15;      % X + 3*Y <= 15
int: cost_x = 5000;
int: cost_y = 3000;

% Variables
var 0..max_budget: x;      % workers on Project X
var 0..(max_budget div 3): y; % workers on Project Y (since X>=0 => 3Y <= 15)

var 0..(cost_x*max_budget + cost_y*(max_budget div 3)): total_cost;

% Constraints
constraint 2*x + y >= min_req;
constraint x + 3*y <= max_budget;

constraint total_cost = cost_x*x + cost_y*y;

% Objective
solve minimize total_cost;