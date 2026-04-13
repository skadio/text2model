% Parameters
int: max_total_hours = 50;
int: min_effectiveness = 20;
int: diff_limit = 10;

int: cost_X = 5;
int: cost_Y = 3;

% Variables
var 0..max_total_hours: x;  % hours of workout X
var 0..max_total_hours: y;  % hours of workout Y
var 0..cost_X*max_total_hours + cost_Y*max_total_hours: total_fatigue;

% Constraints
constraint x + y <= max_total_hours;

constraint 2 * x + y >= min_effectiveness;

constraint abs(x - 3 * y) <= diff_limit;

constraint total_fatigue = cost_X * x + cost_Y * y;

% Objective
solve minimize total_fatigue;