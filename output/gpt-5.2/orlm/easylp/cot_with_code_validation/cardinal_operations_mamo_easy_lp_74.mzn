% Parameters
int: cost_X = 50;
int: cost_Y = 70;
int: contrib_X = 5;
int: contrib_Y = 10;
int: min_total_contrib = 100;
int: max_buildings = 20;

% Variables
var 0..max_buildings: X;
var 0..max_buildings: Y;
var 0..(cost_X * max_buildings + cost_Y * max_buildings): total_cost;

% Constraints
constraint contrib_X * X + contrib_Y * Y >= min_total_contrib;
constraint X + Y <= max_buildings;
constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;