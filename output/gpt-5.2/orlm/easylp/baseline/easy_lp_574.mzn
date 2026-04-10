% Fleet allocation across three routes - all data embedded

int: cost_x1 = 4;
int: cost_x2 = 5;
int: cost_x3 = 6;

int: ub_x1 = 1500;
int: ub_x2 = 1200;
int: ub_x3 = 800;

var 0..ub_x1: x1;
var 0..ub_x2: x2;
var 0..ub_x3: x3;

constraint x1 + x2 <= 2000;
constraint x2 + x3 >= 1000;
constraint x1 - 2 * x3 = 500;

var int: total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "min_total_cost=", show(total_cost), "\n"
];