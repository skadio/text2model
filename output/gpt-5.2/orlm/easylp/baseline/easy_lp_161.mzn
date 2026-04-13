int: max_units = 10;

int: cost_res = 50000;
int: cost_com = 75000;

float: w_res = 0.6;
float: w_com = 0.4;
float: min_weighted = 5.0;

var 0..max_units: X; % residential units
var 0..max_units: Y; % commercial units

constraint X + Y <= max_units;
constraint w_res * int2float(X) + w_com * int2float(Y) >= min_weighted;

var int: total_cost = cost_res * X + cost_com * Y;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "min_total_cost_dollars=", show(total_cost), "\n"
];