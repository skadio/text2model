% Parameters
int: BUDGET = 1000;
int: MIN_EXPR1 = 10;          % 3X + 2Y - Z >= 10
int: MIN_DIFF_ZY = 30;        % Z - Y >= 30

int: costX = 5;
int: costY = 6;
int: costZ = 7;

int: maxX = 500;
int: maxY = 400;
int: minZ = 50;

% Variables
var 0..maxX: X;
var 0..maxY: Y;
var minZ..BUDGET: Z;

var 0..(costX*maxX + costY*maxY + costZ*BUDGET): TotalCost;

% Constraints
constraint X + Y + Z <= BUDGET;
constraint 3*X + 2*Y - Z >= MIN_EXPR1;
constraint Z - Y >= MIN_DIFF_ZY;

constraint TotalCost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize TotalCost;