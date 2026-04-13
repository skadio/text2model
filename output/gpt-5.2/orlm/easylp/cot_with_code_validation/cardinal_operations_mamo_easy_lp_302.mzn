% Parameters
int: budget = 1000;
int: rhs1 = 200;
int: rhs2 = 500;

int: costX = 50;
int: costY = 30;
int: costZ = 20;

% Variables
var 0..budget: X;
var 0..budget: Y;
var 0..budget: Z;

var 0..(costX*budget + costY*budget + costZ*budget): total_cost;

% Constraints
constraint X + Y + Z <= budget;

constraint X - 2*Y + Z >= rhs1;

constraint 2*X + Y - Z <= rhs2;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;