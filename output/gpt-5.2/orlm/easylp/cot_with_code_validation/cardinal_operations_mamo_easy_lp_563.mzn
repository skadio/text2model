% Parameters
int: TotalBudget = 1000;
int: MinDiffXY = 200;
int: MaxZ = 300;

int: CostX = 50;
int: CostY = 30;
int: CostZ = 20;

% Variables
var 0..TotalBudget: X;
var 0..TotalBudget: Y;
var 0..MaxZ: Z;

var 0..(CostX*TotalBudget + CostY*TotalBudget + CostZ*MaxZ): TotalCost;

% Constraints
constraint X + Y + Z = TotalBudget;

constraint X >= Y + MinDiffXY;

constraint TotalCost = CostX*X + CostY*Y + CostZ*Z;

% Objective
solve minimize TotalCost;