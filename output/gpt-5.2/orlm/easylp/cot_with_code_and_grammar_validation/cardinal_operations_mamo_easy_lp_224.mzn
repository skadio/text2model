% Parameters
int: total_budget = 1000;
int: rhs1 = 500;
int: rhs2 = 800;

int: costX = 10;
int: costY = 15;
int: costZ = 20;

% Variables
var 0..total_budget: X;
var 0..total_budget: Y;
var 0..total_budget: Z;

var 0..(costX*total_budget + costY*total_budget + costZ*total_budget): total_cost;

% Constraints
constraint X + Y + Z <= total_budget;
constraint 2*X + Y >= rhs1;
constraint X + 3*Z <= rhs2;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;