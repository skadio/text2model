% Parameters
int: max_budget = 1000;
int: min_effectiveness = 500;
int: max_diff = 200;

int: cost_X = 500;
int: cost_Y = 300;

% Variables
var 0..max_budget: X;
var 0..max_budget: Y;

var 0..(cost_X*max_budget + cost_Y*max_budget): total_cost;

% Constraints
constraint X + Y <= max_budget;

constraint 2*X + Y >= min_effectiveness;

constraint abs(X - Y) <= max_diff;

constraint total_cost = cost_X*X + cost_Y*Y;

% Objective
solve minimize total_cost;