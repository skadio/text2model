% Parameters (with values embedded)
int: BUDGET_MAX = 5000;
int: MIN_GAP_X_vs_2Y = 1000;
int: MIN_GAP_Z_vs_Y = 1500;

int: COST_X = 10;
int: COST_Y = 15;
int: COST_Z = 20;

% Variables
var 0..BUDGET_MAX: X;
var 0..BUDGET_MAX: Y;
var 0..BUDGET_MAX: Z;

var 0..(COST_X*BUDGET_MAX + COST_Y*BUDGET_MAX + COST_Z*BUDGET_MAX): total_cost;

% Constraints
constraint X + Y + Z <= BUDGET_MAX;
constraint X - 2*Y >= MIN_GAP_X_vs_2Y;
constraint Z - Y >= MIN_GAP_Z_vs_Y;

constraint total_cost = COST_X*X + COST_Y*Y + COST_Z*Z;

% Objective
solve minimize total_cost;