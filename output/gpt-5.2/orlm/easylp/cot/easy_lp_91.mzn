% Parameters (with values embedded)
int: total_limit = 1000;
int: min_weighted = 800;
int: max_diff = 200;
int: costX = 4;
int: costY = 3;

% Variables
var 0..total_limit: x;   % units allocated to warehouse X
var 0..total_limit: y;   % units allocated to warehouse Y
var 0..(costX*total_limit + costY*total_limit): total_cost;

% Constraints
constraint x + y <= total_limit;
constraint 2*x + y >= min_weighted;
constraint abs(x - y) <= max_diff;
constraint total_cost = costX*x + costY*y;

% Objective
solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "total_cost=", show(total_cost), "\n"
];