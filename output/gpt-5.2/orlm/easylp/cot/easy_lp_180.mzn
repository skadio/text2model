% Parameters (with values embedded)
int: total_resource_limit = 1000;
int: min_balanced_portfolio = 500;      % 2*X + Y >= 500
int: tech_logistic_limit = 600;         % X + 2*Z <= 600

int: costX = 6;
int: costY = 3;
int: costZ = 5;

% Variables
var 0..total_resource_limit: X;
var 0..total_resource_limit: Y;
var 0..total_resource_limit: Z;

var 0..(costX*total_resource_limit + costY*total_resource_limit + costZ*total_resource_limit): total_cost;

% Constraints
constraint X + Y + Z <= total_resource_limit;
constraint 2*X + Y >= min_balanced_portfolio;
constraint X + 2*Z <= tech_logistic_limit;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];