% Parameters
int: max_total_hours = 50;
int: min_effectiveness = 20;
int: max_balance_diff = 10;

int: cost_x = 5;
int: cost_y = 3;

% Variables
var 0..max_total_hours: x;
var 0..max_total_hours: y;

var 0..(cost_x*max_total_hours + cost_y*max_total_hours): total_fatigue;

% Constraints
constraint x + y <= max_total_hours;

constraint 2*x + y >= min_effectiveness;

constraint abs(x - 3*y) <= max_balance_diff;

constraint total_fatigue = cost_x*x + cost_y*y;

% Objective
solve minimize total_fatigue;