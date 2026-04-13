% Parameters
int: max_acres = 50;
int: min_total_acres = 40;

int: cost_x = 5;
int: cost_y = 10;

int: extra_x_limit = 10;

% Variables
var 0..max_acres: x; % acres of crop X (integer)
var 0..max_acres: y; % acres of crop Y (integer)

% Constraints
constraint x + y <= max_acres;
constraint x + y >= min_total_acres;

% must plant at least twice as much X as Y
constraint x >= 2 * y;

% X cannot exceed (2*Y) by more than 10 acres: x - 2y <= 10
constraint x - 2 * y <= extra_x_limit;

% Objective
solve minimize cost_x * x + cost_y * y;