% Parameters (with values embedded)
int: max_area = 500;
int: min_diverse = 200;
int: max_diff_YZ = 50;
int: min_X_minus_Z = 100; % X - Z >= 100
int: costX = 100;
int: costY = 50;
int: costZ = 75;

% Variables
var 0..max_area: X;
var 0..max_area: Y;
var 0..max_area: Z;

% Constraints
constraint X + Y + Z <= max_area;
constraint 2 * X + Y >= min_diverse;
constraint abs(Y - Z) <= max_diff_YZ;
constraint X - Z >= min_X_minus_Z;

% Objective
var int: total_cost = costX * X + costY * Y + costZ * Z;
solve minimize total_cost;