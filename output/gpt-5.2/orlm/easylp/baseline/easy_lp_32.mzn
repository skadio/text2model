% Fleet allocation between routes X and Y (all data embedded)

int: max_total = 1000;
int: min_x = 400;
int: min_y = 300;

int: cost_x = 50;
int: cost_y = 60;

var int: x; % vehicles on route X
var int: y; % vehicles on route Y

constraint x >= min_x;
constraint y >= min_y;
constraint x + y <= max_total;

var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "min_daily_cost=", show(total_cost), "\n"
];