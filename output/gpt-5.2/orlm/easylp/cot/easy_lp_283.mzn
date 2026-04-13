% Parameters (with values embedded)
int: budget_max = 50;
int: min_X = 10;
int: min_Y = 15;
int: min_Z = 5;

int: cost_X = 500;
int: cost_Y = 400;
int: cost_Z = 300;

% Variables
var 0..budget_max: X;
var 0..budget_max: Y;
var 0..budget_max: Z;

var 0..(budget_max * max([cost_X, cost_Y, cost_Z])): total_cost;

% Constraints
constraint X + Y + Z <= budget_max;

constraint X >= min_X;
constraint Y >= min_Y;
constraint Z >= min_Z;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "minimum_total_investment_cost_dollars=", show(total_cost), "\n"
];