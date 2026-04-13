% Parameters
int: BUDGET = 50000;
int: DIFF_XY = 10000;
int: DIFF_YZ = 5000;

int: COST_X = 1000;
int: COST_Y = 800;
int: COST_Z = 600;

% Variables
var 0..BUDGET: x;
var 0..BUDGET: y;
var 0..BUDGET: z;

var 0..(COST_X*BUDGET + COST_Y*BUDGET + COST_Z*BUDGET): total_cost;

% Constraints
constraint x + y + z <= BUDGET;
constraint x >= y + DIFF_XY;
constraint y >= z + DIFF_YZ;

constraint total_cost = COST_X*x + COST_Y*y + COST_Z*z;

% Objective
solve minimize total_cost;