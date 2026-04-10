% Parameters
int: total_cap = 1000;
int: demand_min = 1500;
int: diff_cap = 300;

int: cost_x = 10;
int: cost_y = 15;

int: x_max = 700;
int: y_max = 500;

% Variables
var 0..x_max: x;
var 0..y_max: y;
var 0..(cost_x * x_max + cost_y * y_max): total_cost;

% Constraints
constraint x + y <= total_cap;
constraint 2 * x + 3 * y >= demand_min;
constraint abs(x - y) <= diff_cap;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;