% Parameters
int: max_total = 50;
int: min_effectiveness = 30;
int: max_diff = 10;
int: cost_x = 5;
int: cost_y = 10;

% Variables
var 0..max_total: X;
var 0..max_total: Y;
var 0..(cost_x*max_total + cost_y*max_total): total_cost;

% Constraints
constraint X + Y <= max_total;
constraint 2*X + Y >= min_effectiveness;
constraint abs(X - 2*Y) <= max_diff;
constraint total_cost = cost_x*X + cost_y*Y;

% Objective
solve minimize total_cost;