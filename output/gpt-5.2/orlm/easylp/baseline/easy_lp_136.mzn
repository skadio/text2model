int: max_total_alloc = 200;
int: min_total_alloc = 50;

int: cost_x = 5;
int: cost_y = 8;

var 0..max_total_alloc: x;
var 0..max_total_alloc: y;

constraint x + y <= max_total_alloc;
constraint x + y >= min_total_alloc;

var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "min_total_cost = ", show(total_cost), "\n"
];