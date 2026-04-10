% Parameters
int: MAX_UNITS = 10000;
int: MIN_STRENGTH = 7000;
int: MAX_DIFF = 2000;
int: COST_X = 5000;
int: COST_Y = 3000;

% Variables
var 0..MAX_UNITS: X;
var 0..MAX_UNITS: Y;
var 0..(COST_X*MAX_UNITS + COST_Y*MAX_UNITS): total_support;

% Constraints
constraint X + Y <= MAX_UNITS;
constraint 2*X + Y >= MIN_STRENGTH;
constraint X - 2*Y <= MAX_DIFF;

constraint total_support = COST_X*X + COST_Y*Y;

% Objective
solve minimize total_support;