int: total_budget_max = 40;

int: x_min = 15;
int: x_max = 30;

int: y_min = 10;
int: y_max = 20;

int: cost_x = 10;
int: cost_y = 5;

var x_min..x_max: X;
var y_min..y_max: Y;

constraint X + Y <= total_budget_max;

var int: total_cost = cost_x * X + cost_y * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "TotalCost = ", show(total_cost), "\n"
];