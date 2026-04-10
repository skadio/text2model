% Parameters (with values embedded)
int: budget_max = 1000;

int: X_lb = 0;
int: X_ub = 600;
int: Y_lb = 0;
int: Y_ub = 400;
int: Z_lb = 0;
int: Z_ub = 300;

int: min_2X_plus_Y = 400;
int: min_Y_plus_Z = 500;

int: benefit_X = 5;
int: benefit_Y = 3;
int: benefit_Z = 1;

% Variables
var X_lb..X_ub: X;
var Y_lb..Y_ub: Y;
var Z_lb..Z_ub: Z;

var 0..budget_max: total_cost;

% Constraints
constraint total_cost = X + Y + Z;
constraint total_cost <= budget_max;

constraint 2*X + Y >= min_2X_plus_Y;
constraint Y + Z >= min_Y_plus_Z;

% Objective
solve minimize total_cost;