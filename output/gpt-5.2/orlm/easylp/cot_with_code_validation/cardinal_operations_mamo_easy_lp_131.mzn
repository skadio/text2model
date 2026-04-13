% Parameters
int: BUDGET_MAX = 10000;
int: IMPACT_MIN = 40000;

int: impactX = 10;
int: impactY = 4;

int: costX = 50;
int: costY = 30;

% Variables
var 0..BUDGET_MAX: x;
var 0..BUDGET_MAX: y;

var 0..(costX * BUDGET_MAX + costY * BUDGET_MAX): total_cost;

% Constraints
constraint x + y <= BUDGET_MAX;
constraint impactX * x + impactY * y >= IMPACT_MIN;

constraint total_cost = costX * x + costY * y;

% Objective
solve minimize total_cost;