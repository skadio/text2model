% Parameters (with values embedded)
int: total_budget_max = 40;
int: X_min = 15;
int: Y_min = 10;
int: X_max = 30;
int: Y_max = 20;

int: cost_X = 10;
int: cost_Y = 5;

% Variables
var X_min..X_max: X;
var Y_min..Y_max: Y;
var int: total_cost;

% Constraints
constraint X + Y <= total_budget_max;

constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;