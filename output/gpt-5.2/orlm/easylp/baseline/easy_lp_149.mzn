int: min_total_goods = 50;
int: max_diff = 30;

int: cost_x = 20;
int: cost_y = 15;

var 0..1000: X;
var 0..1000: Y;

constraint X + Y >= min_total_goods;
constraint abs(X - Y) <= max_diff;

var int: total_cost = cost_x * X + cost_y * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];