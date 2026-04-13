% Parameters
int: min_total = 100;
int: a1 = 5;
int: b1 = -2;
int: rhs1 = 50;
int: costX = 10;
int: costY = 20;

% Variables
var 0..min_total: X;
var 0..min_total: Y;
var 0..(costX*min_total + costY*min_total): total_cost;

% Constraints
constraint X + Y >= min_total;
constraint a1 * X + b1 * Y <= rhs1;

constraint total_cost = costX * X + costY * Y;

% Objective
solve minimize total_cost;