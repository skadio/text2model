% Parameters
int: max_acres = 50;
int: min_total_acres = 40;

int: cost_x = 5;
int: cost_y = 10;

% Constraint parameters:
% Must plant at least twice as much X as Y: X >= 2*Y
% X cannot exceed 2*Y by more than 10: X <= 2*Y + 10

% Variables
var 0..max_acres: X;
var 0..max_acres: Y;

var 0..(cost_x*max_acres + cost_y*max_acres): total_cost;

% Constraints
constraint X + Y <= max_acres;
constraint X + Y >= min_total_acres;

constraint X >= 2 * Y;
constraint X <= 2 * Y + 10;

constraint total_cost = cost_x * X + cost_y * Y;

% Objective
solve minimize total_cost;