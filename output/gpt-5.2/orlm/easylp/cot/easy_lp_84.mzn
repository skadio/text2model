% Parameters (with values embedded)
int: max_total_hours = 40;
int: min_output = 20;
int: costX = 8;
int: costY = 6;

% Variables
var 0..max_total_hours: X;  % hours for team X (integer, non-negative)
var 0..max_total_hours: Y;  % hours for team Y (integer, non-negative)
var 0..(costX*max_total_hours + costY*max_total_hours): total_cost;

% Constraints
constraint X + Y <= max_total_hours;
constraint 2*X + Y >= min_output;
constraint total_cost = costX*X + costY*Y;

% Objective
solve minimize total_cost;