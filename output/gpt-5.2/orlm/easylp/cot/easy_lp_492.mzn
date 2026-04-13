% Parameters (with values embedded)
int: MAX_UNITS = 10000;
int: MIN_STRENGTH = 7000;
int: MAX_DIFF = 2000;

int: costX = 5000;
int: costY = 3000;

% Variables
var 0..MAX_UNITS: X;
var 0..MAX_UNITS: Y;
var 0..(costX*MAX_UNITS + costY*MAX_UNITS): total_support;

% Constraints
constraint X + Y <= MAX_UNITS;
constraint 2*X + Y >= MIN_STRENGTH;
constraint X - 2*Y <= MAX_DIFF;

constraint total_support = costX*X + costY*Y;

% Objective
solve minimize total_support;