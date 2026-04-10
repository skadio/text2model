% Parameters (with values embedded)
int: total_budget_max = 5000;

int: costX = 500;
int: costY = 300;
int: costZ = 1000;

int: maxX = 2500;
int: maxY = 1500;
int: maxZ = 4000;

int: min_X_minus_Y = 50;
int: max_abs_Z_minus_X = 1000;
int: max_abs_Z_minus_Y = 200;

% Variables
var 0..maxX: X;
var 0..maxY: Y;
var 0..maxZ: Z;

var 0..(costX*maxX + costY*maxY + costZ*maxZ): TotalCost;

% Constraints
constraint X + Y + Z <= total_budget_max;

constraint X >= Y + min_X_minus_Y;

constraint abs(Z - X) <= max_abs_Z_minus_X;
constraint abs(Z - Y) <= max_abs_Z_minus_Y;

constraint TotalCost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize TotalCost;