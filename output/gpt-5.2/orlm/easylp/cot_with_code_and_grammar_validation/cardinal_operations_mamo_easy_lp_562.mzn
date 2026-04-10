% Parameters
int: BUDGET_MAX = 1000;
int: MIN_2X_PLUS_Y = 400;
int: MIN_Y_PLUS_Z = 500;

int: benefit_X = 5;
int: benefit_Y = 3;
int: benefit_Z = 1;

int: X_lb = 0; int: X_ub = 600;
int: Y_lb = 0; int: Y_ub = 400;
int: Z_lb = 0; int: Z_ub = 300;

% Variables
var X_lb..X_ub: X;
var Y_lb..Y_ub: Y;
var Z_lb..Z_ub: Z;

var 0..BUDGET_MAX: total_cost;

% Constraints
constraint total_cost = X + Y + Z;

constraint X + Y + Z <= BUDGET_MAX;

constraint 2 * X + Y >= MIN_2X_PLUS_Y;

constraint Y + Z >= MIN_Y_PLUS_Z;

% Objective
solve minimize total_cost;