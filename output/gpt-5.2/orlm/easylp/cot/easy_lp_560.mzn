% Parameters (with values embedded)
int: budget_max = 5000;
int: x_min = 2000;
int: y_max = 1000;
int: z_min = 500;

int: costX = 50;
int: costY = 100;
int: costZ = 150;

% Variables
var 0..budget_max: X;
var 0..budget_max: Y;
var 0..budget_max: Z;

var 0..(costX*budget_max + costY*budget_max + costZ*budget_max): TotalCost;

% Constraints
constraint X >= x_min;
constraint Y <= y_max;
constraint Z >= z_min;

constraint X + Y + Z <= budget_max;

constraint TotalCost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize TotalCost;