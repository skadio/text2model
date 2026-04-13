% Parameters
int: max_total = 100;
int: min_balance = 50;
int: max_diff = 30;
int: cost_x = 2;
int: cost_y = 3;

% Variables
var 0..max_total: X;
var 0..max_total: Y;
var 0..(cost_x*max_total + cost_y*max_total): total_cost;

% Constraints
constraint X + Y <= max_total;
constraint 2*X + Y >= min_balance;
constraint abs(X - Y) <= max_diff;

constraint total_cost = cost_x * X + cost_y * Y;

% Objective
solve minimize total_cost;