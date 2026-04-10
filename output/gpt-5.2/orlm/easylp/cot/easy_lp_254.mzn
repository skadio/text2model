% Parameters (with values embedded)
int: budget_max = 1000;
int: min_YZ = 800;
int: max_diff_XZ = 200;

int: cost_X = 2;
int: cost_Y = 3;
int: cost_Z = 1;

% Variables
var 0..budget_max: X;
var 0..budget_max: Y;
var 0..budget_max: Z;

var 0..(cost_X*budget_max + cost_Y*budget_max + cost_Z*budget_max): total_cost;

% Constraints
constraint X + Y + Z <= budget_max;
constraint Y + Z >= min_YZ;
constraint abs(X - Z) <= max_diff_XZ;

constraint total_cost = cost_X*X + cost_Y*Y + cost_Z*Z;

% Objective
solve minimize total_cost;