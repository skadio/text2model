% Parameters
int: min_total_units = 50;
int: max_weighted_units = 120;          % 2*X + Y <= 120
int: min_balance = 10;                 % X - 3*Y >= 10
int: min_x = 20;
int: min_y = 10;
int: cost_x = 5000;
int: cost_y = 3000;

% Variables
var int: X;
var int: Y;
var int: total_cost;

% Constraints
constraint X >= min_x;
constraint Y >= min_y;

constraint X + Y >= min_total_units;
constraint 2*X + Y <= max_weighted_units;
constraint X - 3*Y >= min_balance;

constraint total_cost = cost_x * X + cost_y * Y;

% Objective
solve minimize total_cost;