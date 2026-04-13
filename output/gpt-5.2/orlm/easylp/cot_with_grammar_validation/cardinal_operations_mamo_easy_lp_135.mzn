% Parameters
int: max_total_invest = 20;
int: min_impact = 10;

int: impact_x = 2;
int: impact_y = 1;

int: cost_x = 4;
int: cost_y = 5;

% Variables
var 0..max_total_invest: x; % investment in Project X
var 0..max_total_invest: y; % investment in Project Y
var 0..(cost_x*max_total_invest + cost_y*max_total_invest): total_cost;

% Constraints
constraint x + y <= max_total_invest;
constraint impact_x * x + impact_y * y >= min_impact;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;