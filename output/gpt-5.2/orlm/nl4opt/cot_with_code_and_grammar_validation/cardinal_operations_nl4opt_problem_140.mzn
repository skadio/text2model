float: reg_in_regular = 0.8;
float: sour_in_regular = 0.2;
float: profit_regular = 3.0;

float: reg_in_sour = 0.1;
float: sour_in_sour = 0.9;
float: profit_sour = 5.0;

float: avail_reg = 80.0;
float: avail_sour = 60.0;

var 0.0..1000.0: x_regular;
var 0.0..1000.0: x_sour;

constraint reg_in_regular * x_regular + reg_in_sour * x_sour <= avail_reg;
constraint sour_in_regular * x_regular + sour_in_sour * x_sour <= avail_sour;

solve maximize profit_regular * x_regular + profit_sour * x_sour;

output [
  "x_regular = ", show(x_regular), " kg\n",
  "x_sour    = ", show(x_sour), " kg\n",
  "profit    = ", show(profit_regular * x_regular + profit_sour * x_sour), "\n"
];