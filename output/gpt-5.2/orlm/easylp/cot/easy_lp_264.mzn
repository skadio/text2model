% Parameters (with values embedded)
int: max_total_staff = 200;

int: min_X = 50;
int: min_Y = 30;
int: min_Z = 20;

int: cost_X = 5000;
int: cost_Y = 4000;
int: cost_Z = 6000;

% Variables
var min_X..max_total_staff: X;
var min_Y..max_total_staff: Y;
var min_Z..max_total_staff: Z;

var 0..(max_total_staff * max(cost_X, max(cost_Y, cost_Z))): total_cost;

% Constraints
constraint X + Y + Z <= max_total_staff;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;