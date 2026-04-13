% Parameters (with values embedded)
int: TotalBudgetMax = 1000;

int: X_max = 500;
int: Y_max = 400;
int: Z_max = 600;

int: costX = 100;
int: costY = 200;
int: costZ = 300;

int: diffLimit = 150;

% Variables
var 0..X_max: X;
var 0..Y_max: Y;
var 0..Z_max: Z;

% Constraints
constraint X + Y + Z <= TotalBudgetMax;

% X should not be less than half of Y: X >= Y/2  <=>  2X >= Y
constraint 2 * X >= Y;

% |Z - (3/4)X| <= 150  <=>  |4Z - 3X| <= 600
constraint abs(4 * Z - 3 * X) <= 4 * diffLimit;

% Y at least 50 more than Z
constraint Y >= Z + 50;

% Objective
% Minimize total cost (cost per unit effectiveness) for optimal (minimum-cost) feasible allocations
var int: TotalCost = costX * X + costY * Y + costZ * Z;
solve minimize TotalCost;