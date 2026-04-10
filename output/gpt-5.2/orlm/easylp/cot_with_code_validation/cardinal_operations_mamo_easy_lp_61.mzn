% Parameters
int: costX = 20;
int: costY = 30;

int: a1 = 5;
int: b1 = 10;
int: rhs1 = 50;

int: a2 = 3;
int: b2 = 4;
int: rhs2 = 36;

% Variables
var 0..100: x;
var 0..100: y;
var 0..10000: total_cost;

% Constraints
constraint a1 * x + b1 * y >= rhs1;
constraint a2 * x + b2 * y <= rhs2;

constraint total_cost = costX * x + costY * y;

% Objective
solve minimize total_cost;