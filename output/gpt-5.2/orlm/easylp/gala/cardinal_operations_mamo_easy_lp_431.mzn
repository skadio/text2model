% Truck allocation between two routes with cost minimization
% All data embedded as requested.

int: max_total_trucks = 500;
int: min_x = 100;
int: min_y = 200;

int: cost_x = 10;   % dollars per truck on route X
int: cost_y = 20;   % dollars per truck on route Y

var min_x..max_total_trucks: x;  % trucks assigned to route X
var min_y..max_total_trucks: y;  % trucks assigned to route Y

constraint x + y <= max_total_trucks;

var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "min_total_operational_cost = ", show(total_cost), "\n"
];