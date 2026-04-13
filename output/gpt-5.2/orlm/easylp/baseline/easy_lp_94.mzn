int: min_total_goods = 1000;
int: max_capacity = 2500;

int: cost_x = 5;
int: cost_y = 3;

var 0..max_capacity: x; % goods to warehouse X
var 0..max_capacity: y; % goods to warehouse Y

constraint x + y >= min_total_goods;
constraint 2*x + y <= max_capacity;

var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n"
];