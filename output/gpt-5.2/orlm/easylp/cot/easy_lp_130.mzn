% Parameters (with values embedded)
int: max_weighted_activities = 5000;
int: min_difference = 100;

float: costX = 0.5;
float: costY = 0.3;

% Variables
var 0..max_weighted_activities: X;  % activities for Project X
var 0..max_weighted_activities: Y;  % activities for Project Y

var float: total_cost;

% Constraints
constraint 2 * X + 3 * Y <= max_weighted_activities;
constraint X - Y >= min_difference;

constraint total_cost = costX * int2float(X) + costY * int2float(Y);

% Objective
solve minimize total_cost;