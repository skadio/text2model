int: budget = 200;

int: perf_min = 400;
int: perf_x = 3;
int: perf_y = 2;

int: diff_min = 50;

int: cost_x = 500;
int: cost_y = 300;

var 0..budget: X;
var 0..budget: Y;

constraint X + Y <= budget;
constraint perf_x * X + perf_y * Y >= perf_min;
constraint abs(X - Y) >= diff_min;

var int: total_cost = cost_x * X + cost_y * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];