% Parameters
int: max_total = 50;
int: costX = 150;
int: costY = 200;
int: costZ = 100;
int: min_efficiency = 60;
int: max_diff_YZ = 10;

% Variables
var 0..max_total: x;
var 0..max_total: y;
var 0..max_total: z;

var 0..(max_total * max(costX, max(costY, costZ))): total_cost;

% Constraints
constraint x + y + z <= max_total;

constraint 2*x + 3*y + z >= min_efficiency;

constraint abs(y - z) <= max_diff_YZ;

constraint total_cost = costX*x + costY*y + costZ*z;

% Objective
solve minimize total_cost;