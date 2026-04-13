% Parameters (with values embedded)
int: max_total_vehicles = 1000;
int: min_X = 200;
int: min_Y = 300;
int: max_X = 500;
int: max_Y = 700;

int: cost_X = 50;
int: cost_Y = 70;

% Variables
var min_X..max_X: X;
var min_Y..max_Y: Y;
var 0..(cost_X*max_X + cost_Y*max_Y): total_support_points;

% Constraints
constraint X + Y <= max_total_vehicles;

constraint total_support_points = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_support_points;