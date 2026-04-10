int: max_bandwidth = 10000;
int: min_effectiveness = 5000;

int: eff_x = 2;
int: eff_y = 3;

float: cost_x = 0.2;
float: cost_y = 0.3;

var 0..max_bandwidth: X;
var 0..max_bandwidth: Y;

constraint X + Y <= max_bandwidth;
constraint eff_x * X + eff_y * Y >= min_effectiveness;

var float: total_cost = cost_x * int2float(X) + cost_y * int2float(Y);

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "effectiveness=", show(eff_x * X + eff_y * Y), "\n",
  "total_cost=", show(total_cost), "\n"
];