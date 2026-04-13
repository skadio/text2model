% Parameters
int: max_total = 200;
int: min_weighted = 100;
int: max_diff = 50;

int: max_x = 150;
int: max_y = 100;

int: cost_x = 5000;
int: cost_y = 3000;

% Variables
var 0..max_x: x;
var 0..max_y: y;
var 0..(cost_x*max_x + cost_y*max_y): total_cost;

% Constraints
constraint x + y <= max_total;
constraint 2*x + y >= min_weighted;
constraint abs(x - y) <= max_diff;
constraint total_cost = cost_x*x + cost_y*y;

% Objective
solve minimize total_cost;