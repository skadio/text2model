% Parameters
int: max_fleet = 1000;
int: min_service = 500;
int: max_diff_YZ = 300;

int: costX = 2;
int: costY = 3;
int: costZ = 4;

% Variables
var 0..max_fleet: x;
var 0..max_fleet: y;
var 0..max_fleet: z;

var 0..(costX*max_fleet + costY*max_fleet + costZ*max_fleet): total_cost;

% Constraints
constraint x + y + z <= max_fleet;

constraint 2*x + y >= min_service;

constraint abs(y - z) <= max_diff_YZ;

constraint total_cost = costX*x + costY*y + costZ*z;

% Objective
solve minimize total_cost;