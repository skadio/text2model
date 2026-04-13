% Parameters
int: max_total = 1000;
int: min_2X_plus_Y = 200;
int: max_X_plus_Z = 300;

int: cost_X = 5;
int: cost_Y = 4;
int: cost_Z = 3;

% Variables
var 0..max_total: X;
var 0..max_total: Y;
var 0..max_total: Z;

var 0..(cost_X*max_total + cost_Y*max_total + cost_Z*max_total): total_cost;

% Constraints
constraint X + Y + Z <= max_total;
constraint 2*X + Y >= min_2X_plus_Y;
constraint X + Z <= max_X_plus_Z;

constraint total_cost = cost_X*X + cost_Y*Y + cost_Z*Z;

% Objective
solve minimize total_cost;