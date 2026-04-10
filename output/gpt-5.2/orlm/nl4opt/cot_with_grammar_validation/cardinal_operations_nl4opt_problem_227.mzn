% Parameters
int: hours_regular = 10;
int: hours_emergency = 6;
int: cost_regular = 300;
int: cost_emergency = 100;

int: min_total_hours = 300;
int: max_budget = 7000;

% Variables
var 0..(max_budget div cost_regular): x_regular;
var 0..(max_budget div cost_emergency): x_emergency;

% Constraints
constraint hours_regular * x_regular + hours_emergency * x_emergency >= min_total_hours;
constraint cost_regular * x_regular + cost_emergency * x_emergency <= max_budget;

% Objective
solve minimize x_regular + x_emergency;