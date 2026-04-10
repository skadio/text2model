% Parameters
int: min_perf = 10;              % 3X + Y >= 10
int: max_capacity = 20;          % 2X + 4Y <= 20
int: cost_x = 4;                 % cost per unit of X
int: cost_y = 6;                 % cost per unit of Y

% Variables
var 0..max_capacity: X;
var 0..max_capacity: Y;
var 0..(cost_x*max_capacity + cost_y*max_capacity): total_cost;

% Constraints
constraint 3*X + Y >= min_perf;
constraint 2*X + 4*Y <= max_capacity;
constraint total_cost = cost_x*X + cost_y*Y;

% Objective
solve minimize total_cost;