% Parameters (with values embedded)
int: min_total_goods = 1000;
int: capacity_limit = 2500;
int: cost_X = 5;
int: cost_Y = 3;

% Variables
var 0..capacity_limit: x; % goods to warehouse X
var 0..capacity_limit: y; % goods to warehouse Y

% Constraints
constraint x + y >= min_total_goods;
constraint 2*x + y <= capacity_limit;

% Objective
solve minimize cost_X * x + cost_Y * y;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "min_cost = ", show(cost_X * x + cost_Y * y), "\n"
];