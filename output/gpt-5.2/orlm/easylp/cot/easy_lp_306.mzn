% Parameters (with values embedded)
int: costX = 2;
int: costY = 3;
int: costZ = 4;

int: totalBudgetMax = 100;
int: yzMax = 70;
int: xyRelationMin = 20;

int: Xmax = 50;
int: Ymax = 40;

% Variables
var 0..Xmax: X;
var 0..Ymax: Y;
var 0..totalBudgetMax: Z;  % implied by X+Y+Z <= 100 and non-negativity

% Constraints
constraint X + Y + Z <= totalBudgetMax;
constraint 2 * X - Y >= xyRelationMin;
constraint Y + Z <= yzMax;

% Objective
var int: TotalCost = costX * X + costY * Y + costZ * Z;
solve minimize TotalCost;