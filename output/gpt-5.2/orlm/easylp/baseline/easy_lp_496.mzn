% Shipping allocation between Port X and Port Y (integer shipments)

int: total_capacity = 2000;
int: cap_per_x = 4;
int: cap_per_y = 5;

int: min_diff_xy = 50;          % X must exceed Y by at least 50
int: max_combo = 1500;          % X + 2Y <= 1500

int: cost_x = 2;
int: cost_y = 3;

var 0..2000: x;  % shipments to Port X
var 0..2000: y;  % shipments to Port Y

constraint cap_per_x * x + cap_per_y * y <= total_capacity;
constraint x - y >= min_diff_xy;
constraint x + 2 * y <= max_combo;

var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "total_cost=", show(total_cost), "\n"
];