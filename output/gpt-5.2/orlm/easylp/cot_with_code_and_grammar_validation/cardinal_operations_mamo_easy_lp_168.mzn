% Parameters
int: total_budget = 1000;
int: minX = 200;
int: minY = 150;
int: minZ = 100;

int: costX = 50;
int: costY = 60;
int: costZ = 70;

% Variables
var 0..total_budget: X;
var 0..total_budget: Y;
var 0..total_budget: Z;

var 0..(costX*total_budget + costY*total_budget + costZ*total_budget): total_cost;

% Constraints
constraint X >= minX;
constraint Y >= minY;
constraint Z >= minZ;

constraint X + Y + Z <= total_budget;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;