int: cost_residential = 1000;
int: cost_commercial  = 500;

int: total_units_max = 50;

int: x_min = 10;   % residential units
int: y_min = 20;   % commercial units

int: diff_max = 10; % x - y <= 10

var x_min..total_units_max: x;
var y_min..total_units_max: y;

constraint x + y <= total_units_max;
constraint x - y <= diff_max;

var int: total_cost = cost_residential * x + cost_commercial * y;

solve minimize total_cost;

output [
  "Residential units (x) = ", show(x), "\n",
  "Commercial units (y)  = ", show(y), "\n",
  "Total cost ($)        = ", show(total_cost), "\n"
];