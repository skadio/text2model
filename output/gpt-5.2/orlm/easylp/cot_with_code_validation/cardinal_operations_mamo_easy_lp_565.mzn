% Parameters
int: TotalMax = 1000;
int: X_over_2Y_min = 100;      % X >= 2*Y + 100
int: YZ_diff_max = 50;         % |Y - Z| <= 50
int: XZ_min = 300;             % X + Z >= 300

int: costX = 2;
int: costY = 3;
int: costZ = 4;

% Operational bounds (not explicitly given beyond nonnegativity and total budget)
int: X_lb = 0; int: X_ub = TotalMax;
int: Y_lb = 0; int: Y_ub = TotalMax;
int: Z_lb = 0; int: Z_ub = TotalMax;

% Variables
var X_lb..X_ub: X;
var Y_lb..Y_ub: Y;
var Z_lb..Z_ub: Z;

var 0..(costX*TotalMax + costY*TotalMax + costZ*TotalMax): TotalCost;

% Constraints
constraint X + Y + Z <= TotalMax;
constraint X >= 2*Y + X_over_2Y_min;
constraint abs(Y - Z) <= YZ_diff_max;
constraint X + Z >= XZ_min;

constraint TotalCost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize TotalCost;