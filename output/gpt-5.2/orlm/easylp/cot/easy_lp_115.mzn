% Parameters (with values embedded)
int: budget_limit = 100;
int: min_effectiveness = 150;

% Effectiveness coefficients
int: eff_X = 2;
int: eff_Y = 3;

% Cost per dollar allocated
int: cost_X = 20;
int: cost_Y = 30;

% Variables
var 0..budget_limit: X;  % dollars allocated to campaign X (integer dollars)
var 0..budget_limit: Y;  % dollars allocated to campaign Y (integer dollars)

var 0..(budget_limit * max(cost_X, cost_Y)): total_cost;

% Constraints
constraint X + Y <= budget_limit;
constraint eff_X * X + eff_Y * Y >= min_effectiveness;

constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];