% Parameters
int: cost_X = 50;
int: cost_Y = 100;

int: cap_total = 2000;
int: min_diff = 500;
int: min_X = 750;

% Variables
var 0..cap_total: X;
var 0..cap_total: Y;

% Constraints
constraint X + Y <= cap_total;
constraint X - 2 * Y >= min_diff;
constraint X >= min_X;

% Objective
solve minimize cost_X * X + cost_Y * Y;