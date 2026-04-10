% Parameters
int: land_limit = 50;
int: coeff_x = 2;
int: coeff_y = 3;

int: min_diff = 10;

int: cost_x = 100;
int: cost_y = 200;

% Variables
var 0..land_limit: x; % acres of crop X
var 0..land_limit: y; % acres of crop Y
var 0..(cost_x*land_limit + cost_y*land_limit): total_cost;

% Constraints
constraint coeff_x * x + coeff_y * y <= land_limit;
constraint x >= y + min_diff;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;