% Parameters (with values embedded)
int: min_total_hires = 10;
int: max_capacity = 20;              % constraint on 2*X + Y
int: cost_X = 50;
int: cost_Y = 30;

% Variables
var 0..max_capacity: X;
var 0..max_capacity: Y;
var 0..(cost_X*max_capacity + cost_Y*max_capacity): total_cost;

% Constraints
constraint X + Y >= min_total_hires;
constraint 2*X + Y <= max_capacity;
constraint total_cost = cost_X*X + cost_Y*Y;

% Objective
solve minimize total_cost;