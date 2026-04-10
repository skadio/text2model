% Parameters (with values embedded)
int: cost_X = 50;
int: cost_Y = 10;

int: resource_limit = 200;   % 2*X + Y <= 200
int: demand_min = 50;        % 4*X + Y >= 50

% Variables
var 0..resource_limit: X;    % units of product X (nonnegative integer)
var 0..resource_limit: Y;    % units of product Y (nonnegative integer)

% Constraints
constraint 2*X + Y <= resource_limit;
constraint 4*X + Y >= demand_min;

% Objective
var 0..(cost_X*resource_limit + cost_Y*resource_limit): total_cost;
constraint total_cost = cost_X*X + cost_Y*Y;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "total_cost=", show(total_cost), "\n"
];