% Parameters
int: total_max = 1000;
int: capacity_min = 2500;
int: diff_max = 300;

int: cost_X = 7;
int: cost_Y = 5;

% Variables
var 0..total_max: X;
var 0..total_max: Y;
var 0..(cost_X*total_max + cost_Y*total_max): total_cost;

% Constraints
constraint X + Y <= total_max;
constraint 3 * X + 2 * Y >= capacity_min;
constraint abs(X - Y) <= diff_max;

constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;