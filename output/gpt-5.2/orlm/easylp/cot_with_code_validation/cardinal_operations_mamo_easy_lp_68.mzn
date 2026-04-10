% Parameters
int: max_acres = 50;
int: min_total_acres = 40;

int: cost_X = 5;
int: cost_Y = 10;

int: max_excess_X_over_2Y = 10;

% Variables
var 0..max_acres: x; % acres of crop X
var 0..max_acres: y; % acres of crop Y

% Constraints
constraint x + y <= max_acres;
constraint x + y >= min_total_acres;

% at least twice as much X as Y
constraint x >= 2 * y;

% X cannot exceed (2*Y + 10)
constraint x <= 2 * y + max_excess_X_over_2Y;

% Objective
solve minimize cost_X * x + cost_Y * y;