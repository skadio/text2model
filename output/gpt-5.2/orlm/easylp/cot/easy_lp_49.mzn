% Parameters (with values embedded)
int: max_total_resources = 50;
int: min_effectiveness = 30;
int: max_balance_diff = 10;
int: costX = 5;
int: costY = 10;

% Variables
var 0..max_total_resources: X;
var 0..max_total_resources: Y;
var int: total_cost;

% Constraints
constraint X + Y <= max_total_resources;
constraint 2*X + Y >= min_effectiveness;
constraint abs(X - 2*Y) <= max_balance_diff;

constraint total_cost = costX * X + costY * Y;

% Objective
solve minimize total_cost;