% Parameters
int: BUDGET_MAX = 200;
int: EFFECT_MIN = 150;
int: DIFF_MAX = 50;

int: COST_X = 50;
int: COST_Y = 80;

% Variables
var 0..BUDGET_MAX: X;
var 0..BUDGET_MAX: Y;

var 0..(COST_X*BUDGET_MAX + COST_Y*BUDGET_MAX): total_cost;

% Constraints
constraint X + Y <= BUDGET_MAX;
constraint 2*X + Y >= EFFECT_MIN;
constraint abs(X - Y) <= DIFF_MAX;

constraint total_cost = COST_X * X + COST_Y * Y;

% Objective
solve minimize total_cost;