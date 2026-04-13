% Parameters
int: TOTAL_EMP = 1000;
int: COST_X = 50;
int: COST_Y = 60;
int: COST_Z = 70;

int: MAX_X = 500;
int: MAX_Y = 400;
int: MAX_Z = 300;

int: DIFF_XY = 200;
int: DIFF_YZ = 100;

% Variables
var 0..MAX_X: x;
var 0..MAX_Y: y;
var 0..MAX_Z: z;

var 0..(COST_X*MAX_X + COST_Y*MAX_Y + COST_Z*MAX_Z): total_cost;

% Constraints
constraint x + y + z <= TOTAL_EMP;

constraint x >= y + DIFF_XY;
constraint y >= z + DIFF_YZ;

constraint total_cost = COST_X*x + COST_Y*y + COST_Z*z;

% Objective
solve minimize total_cost;