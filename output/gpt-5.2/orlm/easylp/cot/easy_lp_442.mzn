% Parameters (with values embedded)
int: total_budget_max = 1000;
int: effectiveness_min = 500;
int: diff_budget_max = 300;

int: cost_X = 5;
int: cost_Y = 3;

% Variables
var 0..total_budget_max: X;  % budget for department X (whole dollars)
var 0..total_budget_max: Y;  % budget for department Y (whole dollars)

var 0..(cost_X * total_budget_max + cost_Y * total_budget_max): total_cost;

% Constraints
constraint X + Y <= total_budget_max;

constraint 2 * X + Y >= effectiveness_min;

constraint abs(X - Y) <= diff_budget_max;

constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;