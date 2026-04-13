% Parameters
int: TOTAL_MAX = 2000;
int: DIFF1_MIN = 500;     % (2*X - Y) >= 500
int: DIFF2_MAX = 1000;    % (X - 2*Y) <= 1000
int: X_MAX = 1500;
int: Y_MAX = 1000;
int: COST_X = 5;
int: COST_Y = 3;

% Variables
var 0..X_MAX: x;
var 0..Y_MAX: y;
var 0..(COST_X * X_MAX + COST_Y * Y_MAX): total_cost;

% Constraints
constraint x + y <= TOTAL_MAX;
constraint 2 * x - y >= DIFF1_MIN;
constraint x - 2 * y <= DIFF2_MAX;

constraint total_cost = COST_X * x + COST_Y * y;

% Objective
solve minimize total_cost;