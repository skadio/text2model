% Parameters
int: BudgetMax = 10000;
int: MinX = 2000;
int: MinY = 1500;
int: MinZ = 500;

float: EffX = 0.5;
float: EffY = 0.3;
float: EffZ = 0.2;

% Variables
var MinX..BudgetMax: X;
var MinY..BudgetMax: Y;
var MinZ..BudgetMax: Z;

% Constraints
constraint X + Y + Z <= BudgetMax;

% (Optional) effectiveness expression (not constrained/optimized here, included for completeness)
var float: total_effectiveness = EffX * int2float(X) + EffY * int2float(Y) + EffZ * int2float(Z);

% Objective
solve minimize X + Y + Z;