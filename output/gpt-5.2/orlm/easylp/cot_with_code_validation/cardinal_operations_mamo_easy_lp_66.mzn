% Parameters
int: min_total = 100;
int: a = 5;
int: b = -2;
int: rhs = 50;
int: cost_x = 10;
int: cost_y = 20;

% Variables
var 0..100: X;
var 0..250: Y;
var 0..6000: total_cost;

% Constraints
constraint X + Y >= min_total;
constraint a * X + b * Y <= rhs;

constraint total_cost = cost_x * X + cost_y * Y;

% Objective
solve minimize total_cost;