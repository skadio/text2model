% Parameters
int: BUDGET_MAX = 100;
int: MIN_STANDARD = 50;
int: BALANCE_MAX_DIFF = 20;

int: COST_X = 5000;
int: COST_Y = 4000;
int: COST_Z = 3000;

% Variables
var 0..BUDGET_MAX: x;
var 0..BUDGET_MAX: y;
var 0..BUDGET_MAX: z;

var 0..(BUDGET_MAX * max([COST_X, COST_Y, COST_Z])): total_cost;

% Constraints
constraint x + y + z <= BUDGET_MAX;

constraint 2 * x + 3 * y >= MIN_STANDARD;

constraint abs(x - z) <= BALANCE_MAX_DIFF;

constraint total_cost = COST_X * x + COST_Y * y + COST_Z * z;

% Objective
solve minimize total_cost;