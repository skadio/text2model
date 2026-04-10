% Parameters
int: max_total = 50;
int: min_total = 10;
int: max_diff = 20;
int: cost_x = 100;
int: cost_y = 200;

% Variables
var 0..max_total: X;
var 0..max_total: Y;
var 0..(cost_x*max_total + cost_y*max_total): total_cost;

% Constraints
constraint 2*X + 3*Y <= max_total;
constraint X + Y >= min_total;
constraint abs(X - Y) <= max_diff;

constraint total_cost = cost_x*X + cost_y*Y;

% Objective
solve minimize total_cost;