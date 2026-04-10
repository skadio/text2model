int: min_total_investment = 30;
int: max_resource_usage = 150;

int: usage_x = 5;
int: usage_y = 3;

int: cost_x = 40;
int: cost_y = 50;

var int: X;
var int: Y;

constraint X >= 0 /\ Y >= 0;
constraint X + Y >= min_total_investment;
constraint usage_x * X + usage_y * Y <= max_resource_usage;

var int: total_cost = cost_x * X + cost_y * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "TotalCost = ", show(total_cost), "\n"
];