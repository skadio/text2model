% Parameters
int: BUDGET = 5000;
int: minX = 1500;
int: minY = 800;
int: minZ = 700;

int: costX = 100;
int: costY = 200;
int: costZ = 50;

% Variables
var minX..BUDGET: X;
var minY..BUDGET: Y;
var minZ..BUDGET: Z;

var 0..(costX*BUDGET + costY*BUDGET + costZ*BUDGET): total_cost;

% Constraints
constraint X + Y + Z <= BUDGET;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;