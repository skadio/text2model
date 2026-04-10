% Parameters
int: budget = 1000;
int: minX = 200;
int: minY = 150;
int: minZ = 250;

int: costX = 500;
int: costY = 300;
int: costZ = 700;

% Variables
var minX..budget: X;
var minY..budget: Y;
var minZ..budget: Z;

var 0..(costX*budget + costY*budget + costZ*budget): total_cost;

% Constraints
constraint X + Y + Z <= budget;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;