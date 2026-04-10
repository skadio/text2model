% Parameters (with values embedded)
int: total_budget = 1000;
int: min_X_minus_Y = 200;
int: max_abs_Z_minus_X = 300;
int: min_Y_plus_Z = 500;

int: impact_X = 2;
int: impact_Y = 3;
int: impact_Z = 4;

% Variables
var 0..total_budget: X;
var 0..total_budget: Y;
var 0..total_budget: Z;

var 0..(impact_X*total_budget + impact_Y*total_budget + impact_Z*total_budget): total_impact;

% Constraints
constraint X + Y + Z <= total_budget;
constraint X >= Y + min_X_minus_Y;
constraint abs(Z - X) <= max_abs_Z_minus_X;
constraint Y + Z >= min_Y_plus_Z;

constraint total_impact = impact_X*X + impact_Y*Y + impact_Z*Z;

% Objective
solve minimize total_impact;