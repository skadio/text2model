% Parameters (with values embedded)
int: R_max = 5000;
int: costX = 100;
int: costY = 200;
int: costZ = 150;

% Variables
var 0..R_max: x;
var 0..R_max: y;
var 0..R_max: z;
var 0..(costX*R_max + costY*R_max + costZ*R_max): total_cost;

% Constraints
constraint x + y + z <= R_max;
constraint x >= 3 * y;
constraint z >= 2 * y;

constraint total_cost = costX * x + costY * y + costZ * z;

% Objective
solve minimize total_cost;