int: max_capacity = 500;
int: min_trucks = 100;
int: max_diff = 50;

int: cost_x = 4;
int: cost_y = 6;

var 0..10000: x; % trucks on route X
var 0..10000: y; % trucks on route Y

constraint 2*x + 3*y <= max_capacity;
constraint x + y >= min_trucks;
constraint abs(x - y) <= max_diff;

var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "total_cost=", show(total_cost), "\n",
  "rounded_total_cost=", show(round(int2float(total_cost))), "\n"
];