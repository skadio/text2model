% Parameters
int: max_total_units = 100;
int: req_2X_plus_Y = 50;
int: req_X_plus_Z = 40;

int: costX = 5000;
int: costY = 4000;
int: costZ = 6000;

% Variables
var 0..max_total_units: x;
var 0..max_total_units: y;
var 0..max_total_units: z;

var 0..(max_total_units * max([costX, costY, costZ])): total_cost;

% Constraints
constraint x + y + z <= max_total_units;

constraint 2*x + y >= req_2X_plus_Y;
constraint x + z >= req_X_plus_Z;

constraint total_cost = costX*x + costY*y + costZ*z;

% Objective
solve minimize total_cost;