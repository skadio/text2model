% Transportation resource allocation (integer optimization)
% All data embedded as requested.

int: total_max = 1000;

int: x_min = 200;
int: y_min = 300;

int: x_max = 500;
int: y_max = 700;

int: cost_x = 50;
int: cost_y = 70;

var x_min..x_max: x;   % units of vehicle type X
var y_min..y_max: y;   % units of vehicle type Y

constraint x + y <= total_max;

var int: total_support = cost_x * x + cost_y * y;

solve minimize total_support;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_support_points = ", show(total_support), "\n"
];