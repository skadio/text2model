% Parameters
% Unit costs for each project
int: costX = 2;
int: costY = 3;
int: costZ = 4;

% Constraint right-hand-sides / limits
int: totalBudgetMax = 100;   % X + Y + Z <= 100
int: minConstraintRHS = 20;  % 2*X - Y >= 20
int: yzBudgetMax = 70;       % Y + Z <= 70

% Explicit upper bounds on X and Y (Z bounded by constraints)
int: xMax = 50;
int: yMax = 40;

% Variables
% Integer allocations (nonnegative) subject to bounds
var 0..xMax: X;
var 0..yMax: Y;
var int: Z;                  % will be constrained to be >= 0 below

% Total cost (integer expression)
var int: totalCost;

% Constraints
% --- Domain / feasibility constraints ---
constraint Z >= 0;

% --- Budget limit across all projects ---
constraint X + Y + Z <= totalBudgetMax;

% --- Policy constraint relating X and Y allocations ---
constraint 2 * X - Y >= minConstraintRHS;

% --- Combined budget limit for projects Y and Z ---
constraint Y + Z <= yzBudgetMax;

% --- Total cost definition (linking) ---
constraint totalCost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize totalCost;