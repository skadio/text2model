% Parameters
int: max_total = 500;
int: min_expr2 = 100;
int: max_expr3 = 200;

int: costX = 50;
int: costY = 30;
int: costZ = 20;

% Variables
var 0..max_total: X;
var 0..max_total: Y;
var 0..max_total: Z;

var 0..(max_total * max(costX, max(costY, costZ))): total_cost;

% Constraints
constraint X + Y + Z <= max_total;

constraint 3*X - Y + Z >= min_expr2;

constraint X - 2*Y - Z <= max_expr3;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;