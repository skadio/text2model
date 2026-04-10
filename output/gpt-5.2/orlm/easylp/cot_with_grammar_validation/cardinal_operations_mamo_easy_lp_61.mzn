% Parameters
int: coeff_effort_X = 5;
int: coeff_effort_Y = 10;
int: min_effort = 50;

int: coeff_quality_X = 3;
int: coeff_quality_Y = 4;
int: max_quality = 36;

int: cost_X = 20;
int: cost_Y = 30;

% Variables
var 0..1000: x; % resources allocated to Task X
var 0..1000: y; % resources allocated to Task Y
var 0..1000000: total_cost;

% Constraints
constraint coeff_effort_X * x + coeff_effort_Y * y >= min_effort;
constraint coeff_quality_X * x + coeff_quality_Y * y <= max_quality;

constraint total_cost = cost_X * x + cost_Y * y;

% Objective
solve minimize total_cost;