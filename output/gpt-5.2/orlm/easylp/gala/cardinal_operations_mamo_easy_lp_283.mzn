% Tourism agency budget allocation across campaigns X, Y, Z
% Minimize total investment cost with integer allocations.

int: total_budget_max = 50;

int: min_X = 10;
int: min_Y = 15;
int: min_Z = 5;

int: cost_X = 500;
int: cost_Y = 400;
int: cost_Z = 300;

var min_X..total_budget_max: X;
var min_Y..total_budget_max: Y;
var min_Z..total_budget_max: Z;

constraint X + Y + Z <= total_budget_max;

var int: total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "TotalBudget = ", show(X + Y + Z), "\n",
  "MinimumTotalCost = $", show(total_cost), "\n"
];