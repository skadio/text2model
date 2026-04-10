% Parameters
int: max_units = 1000;
int: min_strength = 200;          % constraint: 2*X + 1*Y >= 200
int: min_xz = 300;                % constraint: X + Z >= 300

int: costX = 300;
int: costY = 500;
int: costZ = 700;

% Variables
var 0..max_units: X;
var 0..max_units: Y;
var 0..max_units: Z;

var 0..(max_units * max([costX, costY, costZ])): total_cost;

% Constraints
constraint X + Y + Z <= max_units;

constraint 2 * X + Y >= min_strength;

constraint X + Z >= min_xz;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;