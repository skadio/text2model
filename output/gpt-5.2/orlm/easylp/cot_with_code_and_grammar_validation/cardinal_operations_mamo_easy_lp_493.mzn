% Parameters
int: max_vessels = 100;
int: min_capacity = 50;
int: max_diff = 20;

int: cap_x = 2;
int: cap_y = 3;

int: cost_x = 3;
int: cost_y = 2;

% Variables
var 0..max_vessels: x;
var 0..max_vessels: y;
var 0..(cost_x*max_vessels + cost_y*max_vessels): total_cost;

% Constraints
constraint x + y <= max_vessels;
constraint cap_x * x + cap_y * y >= min_capacity;
constraint abs(x - y) <= max_diff;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;