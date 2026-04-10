% Parameters
int: R_max = 10000;
int: req_min = 6000;
int: diff_max = 2000;
int: costX = 5000;
int: costY = 3000;

% Variables
var 0..R_max: x;
var 0..R_max: y;
var 0..(costX*R_max + costY*R_max): total_cost;

% Constraints
constraint x + y <= R_max;
constraint 2*x + y >= req_min;
constraint abs(x - y) <= diff_max;

constraint total_cost = costX*x + costY*y;

% Objective
solve minimize total_cost;