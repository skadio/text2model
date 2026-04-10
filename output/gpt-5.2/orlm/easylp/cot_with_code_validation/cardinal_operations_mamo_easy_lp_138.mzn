% Parameters
int: min_total_units = 100;
int: strength_limit = 600;
int: strength_X = 5;
int: strength_Y = 3;
int: cost_X = 5000;
int: cost_Y = 3000;

% Variables
var 0..strength_limit: X;
var 0..strength_limit: Y;
var 0..(cost_X*strength_limit + cost_Y*strength_limit): total_cost;

% Constraints
constraint X + Y >= min_total_units;
constraint strength_X * X + strength_Y * Y <= strength_limit;
constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;