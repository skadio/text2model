% Parameters
int: costX = 7;
int: costY = 9;

int: a1 = 4;
int: b1 = 5;
int: rhs1 = 1000;

int: a2 = 3;
int: b2 = 2;
int: rhs2 = 200;

int: rhs3 = 300;

% Variables
var 0..300: x;
var 0..300: y;

% Constraints
constraint a1 * x + b1 * y <= rhs1;
constraint a2 * x - b2 * y >= rhs2;
constraint x + y <= rhs3;

% Objective
var int: total_cost = costX * x + costY * y;
solve minimize total_cost;