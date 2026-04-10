% Parameters (with values embedded)
int: max_units = 100;
int: req_strength = 50;
int: coef_X = 5;
int: coef_Y = 3;
int: diff_limit = 30;

int: cost_X = 500;
int: cost_Y = 600;
int: cost_Z = 700;

% Variables
var 0..max_units: X;
var 0..max_units: Y;
var 0..max_units: Z;
var 0..(max_units * cost_Z): total_support;

% Constraints
constraint X + Y + Z <= max_units;
constraint coef_X * X + coef_Y * Y >= req_strength;
constraint abs(Z - Y) <= diff_limit;
constraint total_support = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_support;