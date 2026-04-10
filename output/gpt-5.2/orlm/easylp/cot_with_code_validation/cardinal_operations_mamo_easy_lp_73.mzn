% Parameters
int: max_land = 50;
int: coeff_x = 2;
int: coeff_y = 3;

int: min_diff = 10; % X must be at least 10 more than Y

int: cost_x = 100;
int: cost_y = 200;

% Variables
var 0..max_land: x; % acres of crop X
var 0..max_land: y; % acres of crop Y
var 0..(cost_x*max_land + cost_y*max_land): total_cost;

% Constraints
constraint coeff_x * x + coeff_y * y <= max_land;
constraint x >= y + min_diff;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;