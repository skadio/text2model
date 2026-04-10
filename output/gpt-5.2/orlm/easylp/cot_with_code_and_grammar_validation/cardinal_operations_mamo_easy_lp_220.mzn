% Parameters
int: BUDGET_MAX = 1000;
int: minX = 300;
int: minY = 200;
int: minZ = 500;

int: costX = 10;
int: costY = 8;
int: costZ = 6;

% Variables
var minX..BUDGET_MAX: X;
var minY..BUDGET_MAX: Y;
var minZ..BUDGET_MAX: Z;

var 0..(costX*BUDGET_MAX + costY*BUDGET_MAX + costZ*BUDGET_MAX): total_expenditure;

% Constraints
constraint X + Y + Z <= BUDGET_MAX;

constraint total_expenditure = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_expenditure;