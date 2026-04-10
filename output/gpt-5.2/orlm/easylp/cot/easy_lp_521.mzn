% Parameters (with values embedded)
int: min_diversification = 10;
int: max_risk_exposure = 15;
int: x_more_than_y = 3;
int: budget_limit = 20;

int: costX = 7;
int: costY = 3;
int: costZ = 5;

% Variables
var 0..budget_limit: X;
var 0..budget_limit: Y;
var 0..budget_limit: Z;

var 0..(costX*budget_limit + costY*budget_limit + costZ*budget_limit): total_cost;

% Constraints
constraint 2*X + Y + Z >= min_diversification;
constraint X - Y + 2*Z <= max_risk_exposure;
constraint X = Y + x_more_than_y;
constraint X + Y + Z <= budget_limit;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "minimum_cost_rounded=", show(total_cost), "\n"
];