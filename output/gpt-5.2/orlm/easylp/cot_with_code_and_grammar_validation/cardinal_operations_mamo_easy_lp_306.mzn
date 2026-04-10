% Parameters
int: costX = 2;
int: costY = 3;
int: costZ = 4;

int: totalBudgetMax = 100;
int: yzBudgetMax = 70;
int: minExpr = 20;

int: Xmax = 50;
int: Ymax = 40;

% Variables
var 0..Xmax: X;
var 0..Ymax: Y;
var 0..totalBudgetMax: Z;

var int: totalCost;

% Constraints
constraint X + Y + Z <= totalBudgetMax;
constraint 2 * X - Y >= minExpr;
constraint Y + Z <= yzBudgetMax;

constraint totalCost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize totalCost;