% Parameters (with values embedded)
int: BUDGET = 1000;
int: A1 = 5;     % coefficient for X in constraint 1
int: B1 = -2;    % coefficient for Y in constraint 1
int: RHS1 = 200;

int: DIFF_ZY_MAX = 300;
int: X_MINUS_Z_MIN = 50;

int: costX = 2;
int: costY = 3;
int: costZ = 4;

% Variables
var 0..BUDGET: X;
var 0..BUDGET: Y;
var 0..BUDGET: Z;

var 0..(costX*BUDGET + costY*BUDGET + costZ*BUDGET): total_cost;

% Constraints
constraint X + Y + Z <= BUDGET;

constraint A1 * X + B1 * Y >= RHS1;

constraint Z - Y <= DIFF_ZY_MAX;

constraint X >= Z + X_MINUS_Z_MIN;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;