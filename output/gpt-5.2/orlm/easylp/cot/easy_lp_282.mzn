% Parameters (with values embedded)
int: BUDGET_MAX = 5000;
int: MIN_X = 1500;
int: MIN_Y = 800;
int: MIN_Z = 700;

int: COST_X = 100;
int: COST_Y = 200;
int: COST_Z = 50;

% Variables
var MIN_X..BUDGET_MAX: X;
var MIN_Y..BUDGET_MAX: Y;
var MIN_Z..BUDGET_MAX: Z;

var 0..(COST_X*BUDGET_MAX + COST_Y*BUDGET_MAX + COST_Z*BUDGET_MAX): total_cost;

% Constraints
constraint X + Y + Z <= BUDGET_MAX;

constraint total_cost = COST_X * X + COST_Y * Y + COST_Z * Z;

% Objective
solve minimize total_cost;