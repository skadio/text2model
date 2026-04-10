% Parameters
int: max_total = 20;
int: min_feas = 5;
int: max_diff = 10;

int: costX = 100;
int: costY = 200;
int: costZ = 150;

% Variables
var 0..max_total: X;
var 0..max_total: Y;
var 0..max_total: Z;

var 0..(max_total * max([costX, costY, costZ])): total_cost;

% Constraints
constraint X + Y + Z <= max_total;
constraint 2 * X + Y >= min_feas;
constraint abs(Y - Z) <= max_diff;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;