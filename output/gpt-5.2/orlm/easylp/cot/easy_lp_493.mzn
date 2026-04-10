% Parameters (with values embedded)
int: max_vessels = 100;
int: min_capacity = 50;
int: max_diff = 20;
int: cost_X = 3;
int: cost_Y = 2;

% Variables
var 0..max_vessels: X;
var 0..max_vessels: Y;
var 0..(cost_X*max_vessels + cost_Y*max_vessels): total_cost;

% Constraints
constraint X + Y <= max_vessels;
constraint 2*X + 3*Y >= min_capacity;
constraint abs(X - Y) <= max_diff;
constraint total_cost = cost_X*X + cost_Y*Y;

% Objective
solve minimize total_cost;