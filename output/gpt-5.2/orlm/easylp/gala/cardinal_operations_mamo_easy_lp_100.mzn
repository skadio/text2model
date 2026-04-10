% HR allocation to two projects: minimize total cost
% All data embedded as required.

int: max_total = 100;

int: min_x = 40;
int: min_y = 20;

int: cost_x = 50;
int: cost_y = 30;

var min_x..max_total: x;  % employees on Project X
var min_y..max_total: y;  % employees on Project Y

constraint x + y <= max_total;

var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "Employees_X = ", show(x), "\n",
  "Employees_Y = ", show(y), "\n",
  "TotalCost = ", show(total_cost), "\n"
];