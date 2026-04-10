% Resource allocation between distribution centers X and Y
% Minimize cost subject to constraints; all data embedded.

int: total_resources = 5000;
int: cost_x = 4;
int: cost_y = 3;

int: min_service = 1000;

var 0..total_resources: x; % units allocated to center X
var 0..total_resources: y; % units allocated to center Y

constraint x + y <= total_resources;
constraint x >= 2 * y;
constraint 2 * x + y >= min_service;

var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];