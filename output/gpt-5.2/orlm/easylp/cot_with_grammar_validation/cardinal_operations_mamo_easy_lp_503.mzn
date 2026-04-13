% Parameters
int: TotalBudget = 1000;

int: costX = 100;
int: costY = 200;
int: costZ = 300;

int: maxX = 500;
int: maxY = 400;
int: maxZ = 600;

int: diffLimit = 150;

% Variables
var 0..maxX: X;
var 0..maxY: Y;
var 0..maxZ: Z;

var 0..(costX*maxX + costY*maxY + costZ*maxZ): TotalCost;

% Constraints
constraint X + Y + Z <= TotalBudget;

% X should not be less than half of Y  => 2X >= Y
constraint 2 * X >= Y;

% |Z - (3/4)X| <= 150  => |4Z - 3X| <= 600
constraint abs(4 * Z - 3 * X) <= 4 * diffLimit;

% Y at least 50 more than Z
constraint Y >= Z + 50;

% Cost definition
constraint TotalCost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize TotalCost;