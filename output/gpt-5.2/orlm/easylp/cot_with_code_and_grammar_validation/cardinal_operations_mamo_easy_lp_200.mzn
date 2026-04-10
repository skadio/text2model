% Parameters
int: BUDGET_MAX = 10000;

int: X_MIN = 200;
int: X_MAX = 5000;

int: Y_MIN = 100;
int: Y_MAX = 4000;

int: Z_MIN = 800;
int: Z_MAX = BUDGET_MAX; % implicit upper bound from total budget

int: COST_X = 50;
int: COST_Y = 30;
int: COST_Z = 20;

% Use scaled percentages to keep everything integer:
% 0.07*X - 0.02*Y - 0.05*Z >= 0  <=>  7X - 2Y - 5Z >= 0 (after multiplying by 100)
int: RX = 7;
int: RY = -2;
int: RZ = -5;

int: DIFF_MIN = 3000;

% Variables
var X_MIN..X_MAX: X;
var Y_MIN..Y_MAX: Y;
var Z_MIN..Z_MAX: Z;

var 0..(COST_X*X_MAX + COST_Y*Y_MAX + COST_Z*Z_MAX): total_cost;

% Constraints
constraint X + Y + Z <= BUDGET_MAX;

constraint RX * X + RY * Y + RZ * Z >= 0;

constraint X - 2 * Y + Z >= DIFF_MIN;

constraint total_cost = COST_X * X + COST_Y * Y + COST_Z * Z;

% Objective
solve minimize total_cost;