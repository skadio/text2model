% Parameters (with values embedded)
int: max_total_tourists = 50;
int: min_X = 10;
int: min_Y = 5;
int: min_Z = 8;

int: cost_X = 100;
int: cost_Y = 80;
int: cost_Z = 150;

% Variables
var min_X..max_total_tourists: X;
var min_Y..max_total_tourists: Y;
var min_Z..max_total_tourists: Z;
var 0..(max_total_tourists * max([cost_X, cost_Y, cost_Z])): total_cost;

% Constraints
constraint X + Y + Z <= max_total_tourists;
constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;