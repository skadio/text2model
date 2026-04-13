% Parameters
int: BUDGET_MAX = 1000;
int: YZ_MIN = 800;
int: XZ_DIFF_MAX = 200;

int: COST_X = 2;
int: COST_Y = 3;
int: COST_Z = 1;

% Variables
var 0..BUDGET_MAX: x;
var 0..BUDGET_MAX: y;
var 0..BUDGET_MAX: z;

var 0..(COST_X*BUDGET_MAX + COST_Y*BUDGET_MAX + COST_Z*BUDGET_MAX): total_cost;

% Constraints
constraint x + y + z <= BUDGET_MAX;
constraint y + z >= YZ_MIN;
constraint abs(x - z) <= XZ_DIFF_MAX;

constraint total_cost = COST_X*x + COST_Y*y + COST_Z*z;

% Objective
solve minimize total_cost;