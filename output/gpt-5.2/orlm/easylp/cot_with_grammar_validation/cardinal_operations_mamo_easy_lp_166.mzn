% Parameters
int: total_cap = 1000;
int: min_xy = 200;
int: min_y2z = 300;

int: costX = 10;
int: costY = 15;
int: costZ = 20;

% Variables
var 0..total_cap: x;
var 0..total_cap: y;
var 0..total_cap: z;

var 0..(costX*total_cap + costY*total_cap + costZ*total_cap): total_cost;

% Constraints
constraint x + y + z <= total_cap;

constraint x >= 2 * y;
constraint x + y >= min_xy;

constraint y + 2 * z >= min_y2z;

constraint total_cost = costX * x + costY * y + costZ * z;

% Objective
solve minimize total_cost;