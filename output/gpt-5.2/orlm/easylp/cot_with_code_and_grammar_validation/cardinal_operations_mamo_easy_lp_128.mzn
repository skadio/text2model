% Parameters
int: cost_X = 20;
int: cost_Y = 30;
int: eff_X = 3;
int: eff_Y = 1;
int: min_effectiveness = 10;
int: cap_X = 1;
int: cap_Y = 5;
int: max_capacity = 50;

% Variables
var 0..max_capacity: x; % units of Project X
var 0..max_capacity: y; % units of Project Y
var 0..(cost_X*max_capacity + cost_Y*max_capacity): total_cost;

% Constraints
constraint eff_X * x + eff_Y * y >= min_effectiveness;
constraint cap_X * x + cap_Y * y <= max_capacity;
constraint total_cost = cost_X * x + cost_Y * y;

% Objective
solve minimize total_cost;