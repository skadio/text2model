% Parameters
int: capacity = 5000;
int: min_steel = 1000;
int: min_aluminum = 2000;
int: cost_steel = 20;
int: cost_aluminum = 30;

% Variables
var 0..capacity: steel;
var 0..capacity: aluminum;
var 0..(capacity * max(cost_steel, cost_aluminum)): total_cost;

% Constraints
constraint steel + aluminum <= capacity;
constraint steel >= min_steel;
constraint aluminum >= min_aluminum;
constraint total_cost = cost_steel * steel + cost_aluminum * aluminum;

% Objective
solve minimize total_cost;