% Parameters
int: budget = 1000;
int: min_effectiveness = 800;
int: max_diff_XY = 300;

int: eff_X = 3;
int: eff_Y = 2;
int: eff_Z = 1;

int: cost_X = 2;
int: cost_Y = 3;
int: cost_Z = 1;

% Variables
var 0..budget: X;
var 0..budget: Y;
var 0..budget: Z;

var 0..(cost_X*budget + cost_Y*budget + cost_Z*budget): total_cost;

% Constraints
constraint X + Y + Z <= budget;
constraint eff_X * X + eff_Y * Y + eff_Z * Z >= min_effectiveness;
constraint abs(X - Y) <= max_diff_XY;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;