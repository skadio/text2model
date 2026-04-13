% Parameters
int: MAX_UNITS = 150;
int: MIN_STRENGTH = 100;
int: MAX_DIFF_ZX = 30;
int: MIN_DIFF_YZ = 20;

int: COST_X = 10000;
int: COST_Y = 2000;
int: COST_Z = 500;

% Variables
var 0..MAX_UNITS: X;
var 0..MAX_UNITS: Y;
var 0..MAX_UNITS: Z;

var 0..(MAX_UNITS * max([COST_X, COST_Y, COST_Z])): total_support;

% Constraints
constraint X + Y + Z <= MAX_UNITS;

constraint 3 * X + 4 * Y >= MIN_STRENGTH;

constraint abs(Z - X) <= MAX_DIFF_ZX;

constraint Y - Z >= MIN_DIFF_YZ;

constraint total_support = COST_X * X + COST_Y * Y + COST_Z * Z;

% Objective
solve minimize total_support;