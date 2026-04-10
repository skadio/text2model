% Parameters
int: total_personnel = 200;
int: min_X = 50;
int: min_Y = 30;
int: min_Z = 20;

int: cost_X = 5000;
int: cost_Y = 4000;
int: cost_Z = 6000;

% Variables
var min_X..total_personnel: X;
var min_Y..total_personnel: Y;
var min_Z..total_personnel: Z;

var 0..(total_personnel * max([cost_X, cost_Y, cost_Z])): total_cost;

% Constraints
constraint X + Y + Z <= total_personnel;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;