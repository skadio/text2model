% Parameters (with values embedded)
int: MAX_TOTAL = 2000;
int: MIN_DIFF_X_2Y = 1000;
int: MIN_DIFF_Z_Y = 500;

int: costX = 3;
int: costY = 2;
int: costZ = 1;

% Variables
var 0..MAX_TOTAL: X;
var 0..MAX_TOTAL: Y;
var 0..MAX_TOTAL: Z;

var 0..(costX*MAX_TOTAL + costY*MAX_TOTAL + costZ*MAX_TOTAL): TotalCost;

% Constraints
constraint X + Y + Z <= MAX_TOTAL;

% "at least a 1000 unit difference" between X and 2*Y  => |X - 2Y| >= 1000
constraint abs(X - 2*Y) >= MIN_DIFF_X_2Y;

% "difference between Z and Y must be at least 500" => |Z - Y| >= 500
constraint abs(Z - Y) >= MIN_DIFF_Z_Y;

constraint TotalCost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize TotalCost;