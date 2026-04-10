% Parameters
int: total_budget = 1000;

int: maxX = 500;
int: maxY = 400;
int: maxZ = 600;

int: costX = 100;
int: costY = 200;
int: costZ = 300;

int: diff_bound = 150;

% Variables
var 0..maxX: X;
var 0..maxY: Y;
var 0..maxZ: Z;

% Constraints
constraint X + Y + Z <= total_budget;

% X should not be less than half of Y: X >= Y/2  <=>  2X >= Y
constraint 2 * X >= Y;

% |Z - (3/4)X| <= 150  <=>  |4Z - 3X| <= 600
constraint abs(4 * Z - 3 * X) <= 4 * diff_bound;

% Y at least 50 more than Z
constraint Y >= Z + 50;

% Objective
% "cost per unit effectiveness" => minimize total cost for given allocations
solve minimize costX * X + costY * Y + costZ * Z;