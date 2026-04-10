% Parameters
int: cost_X = 50;
int: cost_Y = 70;

int: contrib_X = 5;
int: contrib_Y = 10;

int: min_total_contrib = 100;
int: max_buildings = 20;

% Variables
var 0..max_buildings: x; % number of type X buildings
var 0..max_buildings: y; % number of type Y buildings
var 0..(cost_X*max_buildings + cost_Y*max_buildings): total_cost;

% Constraints
constraint contrib_X * x + contrib_Y * y >= min_total_contrib;
constraint x + y <= max_buildings;
constraint total_cost = cost_X * x + cost_Y * y;

% Objective
solve minimize total_cost;