% Parameters
int: total_limit = 1000;
int: demand_min = 1500;
int: diff_limit = 300;

int: cost_x = 10;
int: cost_y = 15;

int: max_x = 700;
int: max_y = 500;

% Variables
var 0..max_x: x;
var 0..max_y: y;
var 0..(cost_x*max_x + cost_y*max_y): total_cost;

% Constraints
constraint x + y <= total_limit;
constraint 2*x + 3*y >= demand_min;
constraint abs(x - y) <= diff_limit;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;