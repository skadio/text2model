% Parameters
int: min_total = 50;
int: rhs1 = 30;
int: rhs2 = 10;

int: costX = 5;
int: costY = 3;
int: costZ = 2;

% Variables
var 0..min_total: x;
var 0..min_total: y;
var 0..min_total: z;

var 0..(costX*min_total + costY*min_total + costZ*min_total): total_cost;

% Constraints
constraint x + y + z >= min_total;

constraint 4*x - y <= rhs1;

constraint z - 2*y >= rhs2;

constraint total_cost = costX*x + costY*y + costZ*z;

% Objective
solve minimize total_cost;