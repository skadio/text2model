% Parameters (with values embedded)
int: costX = 50;
int: costY = 70;
int: req_units = 100;
int: contribX = 5;
int: contribY = 10;
int: max_buildings = 20;

% Variables
var 0..max_buildings: X;
var 0..max_buildings: Y;

% Constraints
constraint contribX * X + contribY * Y >= req_units;
constraint X + Y <= max_buildings;

% Objective
var int: total_cost = costX * X + costY * Y;
solve minimize total_cost;