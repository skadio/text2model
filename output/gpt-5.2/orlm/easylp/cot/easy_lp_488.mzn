% Parameters (with values embedded)
int: total_resource_limit = 10000;
int: strategic_minimum = 6000;
int: balance_limit = 2000;

int: cost_X = 5000;   % dollars per unit for division X
int: cost_Y = 3000;   % dollars per unit for division Y

% Variables
var 0..total_resource_limit: X;
var 0..total_resource_limit: Y;
var 0..(cost_X * total_resource_limit + cost_Y * total_resource_limit): total_cost;

% Constraints
constraint X + Y <= total_resource_limit;
constraint 2 * X + Y >= strategic_minimum;
constraint abs(X - Y) <= balance_limit;

constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;