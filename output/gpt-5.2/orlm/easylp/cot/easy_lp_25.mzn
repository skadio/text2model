% Parameters (with values embedded)
int: cost_X = 5;
int: cost_Y = 10;
int: min_X = 30;
int: min_Y = 20;
int: max_total = 100;

% Variables
var min_X..max_total: X;
var min_Y..max_total: Y;

% Constraints
constraint X + Y <= max_total;

% Objective
solve minimize cost_X * X + cost_Y * Y;