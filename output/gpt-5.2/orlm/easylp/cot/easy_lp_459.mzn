% Parameters (with values embedded)
int: min_total_hours = 50;
int: max_weighted_hours = 120; % 2*X + Y <= 120
int: cost_X = 8;
int: cost_Y = 10;

% Variables
var 0..max_weighted_hours: X; % hours for task X (integer)
var 0..max_weighted_hours: Y; % hours for task Y (integer)
var 0..(cost_Y * max_weighted_hours + cost_X * max_weighted_hours): total_cost;

% Constraints
constraint X + Y >= min_total_hours;
constraint 2*X + Y <= max_weighted_hours;
constraint X >= Y;

constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;