% Parameters
int: max_total = 1000;
int: aX = 2;
int: aY = 3;
int: min_weighted = 500;
int: max_mix = 400;
int: y_minus_z = 100;

int: cX = 5;
int: cY = 7;
int: cZ = 3;

% Variables
var 0..max_total: x;
var 0..max_total: y;
var 0..max_total: z;

var 0..(cX*max_total + cY*max_total + cZ*max_total): total_cost;

% Constraints
constraint x + y + z <= max_total;
constraint aX * x + aY * y >= min_weighted;
constraint x + z - y <= max_mix;
constraint y >= z + y_minus_z;

constraint total_cost = cX * x + cY * y + cZ * z;

% Objective
solve minimize total_cost;