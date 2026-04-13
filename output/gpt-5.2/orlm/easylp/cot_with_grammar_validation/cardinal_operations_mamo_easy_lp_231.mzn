% Parameters
int: max_acres = 1000;
int: min_x = 200;
int: min_y = 150;
int: min_z = 100;

int: cost_x = 10;
int: cost_y = 20;
int: cost_z = 30;

% Variables
var min_x..max_acres: acres_x;
var min_y..max_acres: acres_y;
var min_z..max_acres: acres_z;

var 0..(cost_x*max_acres + cost_y*max_acres + cost_z*max_acres): total_cost;

% Constraints
constraint acres_x + acres_y + acres_z <= max_acres;

constraint total_cost = cost_x * acres_x + cost_y * acres_y + cost_z * acres_z;

% Objective
solve minimize total_cost;