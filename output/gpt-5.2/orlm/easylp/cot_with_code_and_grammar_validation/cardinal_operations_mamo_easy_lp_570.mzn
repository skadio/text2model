% Parameters
int: MAX_UNITS = 1000;
int: MIN_2X_PLUS_Y = 200;
int: MAX_DIFF_XZ = 50;
int: MIN_Y_PLUS_Z = 400;

int: COST_X = 500;
int: COST_Y = 300;
int: COST_Z = 700;

% Variables
var 0..MAX_UNITS: x;
var 0..MAX_UNITS: y;
var 0..MAX_UNITS: z;

var 0..(COST_X*MAX_UNITS + COST_Y*MAX_UNITS + COST_Z*MAX_UNITS): total_support;

% Constraints
constraint x + y + z <= MAX_UNITS;
constraint 2*x + y >= MIN_2X_PLUS_Y;
constraint abs(x - z) <= MAX_DIFF_XZ;
constraint y + z >= MIN_Y_PLUS_Z;

constraint total_support = COST_X*x + COST_Y*y + COST_Z*z;

% Objective
solve minimize total_support;