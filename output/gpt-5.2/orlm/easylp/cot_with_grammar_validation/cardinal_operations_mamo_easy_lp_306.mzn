% Parameters
int: costX = 2;
int: costY = 3;
int: costZ = 4;

int: total_budget_max = 100;
int: yz_budget_max = 70;

int: x_max = 50;
int: y_max = 40;

% Variables
var 0..x_max: X;
var 0..y_max: Y;
var 0..total_budget_max: Z;

var 0..(costX*x_max + costY*y_max + costZ*total_budget_max): total_cost;

% Constraints
constraint X + Y + Z <= total_budget_max;
constraint 2*X - Y >= 20;
constraint Y + Z <= yz_budget_max;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;