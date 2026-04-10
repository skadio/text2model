% Parameters
int: max_units = 10000;
int: min_effectiveness = 20000;

int: eff_X = 5;
int: eff_Y = 3;
int: eff_Z = 7;

int: cost_X = 500;
int: cost_Y = 300;
int: cost_Z = 700;

% Variables
var 0..max_units: X;
var 0..max_units: Y;
var 0..max_units: Z;

var 0..(max_units * max(cost_X, max(cost_Y, cost_Z))): total_cost;

% Constraints
constraint X + Y + Z <= max_units;

constraint eff_X * X + eff_Y * Y + eff_Z * Z >= min_effectiveness;

constraint X >= Y;
constraint Z <= Y;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;