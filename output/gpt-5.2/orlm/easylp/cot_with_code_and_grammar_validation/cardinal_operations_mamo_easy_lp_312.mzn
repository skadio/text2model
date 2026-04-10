% Parameters
int: TOTAL_MAX = 1000;
int: YZ_MAX = 800;

int: COST_X = 500;
int: COST_Y = 700;
int: COST_Z = 300;

% Variables
var 0..TOTAL_MAX: x;
var 0..TOTAL_MAX: y;
var 0..TOTAL_MAX: z;

var 0..(COST_X*TOTAL_MAX + COST_Y*TOTAL_MAX + COST_Z*TOTAL_MAX): total_cost;

% Constraints
constraint x + y + z <= TOTAL_MAX;

constraint x >= 2*y + 200;

constraint y + z <= YZ_MAX;

constraint total_cost = COST_X*x + COST_Y*y + COST_Z*z;

% Objective
solve minimize total_cost;