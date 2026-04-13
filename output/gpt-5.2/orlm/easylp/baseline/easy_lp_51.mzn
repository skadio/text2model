% Retail stocking optimization (integer variables, embedded data)

int: max_items = 200;
int: demand_min = 150;

int: cost_X = 5;
int: cost_Y = 10;

int: demand_X = 3;
int: demand_Y = 2;

var 0..max_items: X;
var 0..max_items: Y;

constraint X + Y <= max_items;
constraint demand_X * X + demand_Y * Y >= demand_min;

var int: total_cost = cost_X * X + cost_Y * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost ($, nearest dollar) = ", show(total_cost), "\n"
];