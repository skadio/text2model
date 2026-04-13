% Parameters (with values embedded)
int: budget = 50000;
int: diffXY = 10000;
int: diffYZ = 5000;

int: costX = 1000;
int: costY = 800;
int: costZ = 600;

% Variables
var 0..budget: X;
var 0..budget: Y;
var 0..budget: Z;

var 0..(costX*budget + costY*budget + costZ*budget): total_cost;

% Constraints
constraint X + Y + Z <= budget;

constraint X >= Y + diffXY;
constraint Y >= Z + diffYZ;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;