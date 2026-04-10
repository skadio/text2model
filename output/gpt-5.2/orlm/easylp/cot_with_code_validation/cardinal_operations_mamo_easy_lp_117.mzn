% Parameters
int: max_total_groups = 20;
int: min_diversity = 10;          % 2*X + Y >= 10
int: max_diff = 5;               % |X - Y| <= 5
int: cost_X = 100;
int: cost_Y = 50;
int: max_X = 15;
int: max_Y = 10;

% Variables
var 0..max_X: X;
var 0..max_Y: Y;
var 0..(cost_X*max_X + cost_Y*max_Y): total_cost;

% Constraints
constraint X + Y <= max_total_groups;
constraint 2*X + Y >= min_diversity;
constraint abs(X - Y) <= max_diff;
constraint total_cost = cost_X*X + cost_Y*Y;

% Objective
solve minimize total_cost;