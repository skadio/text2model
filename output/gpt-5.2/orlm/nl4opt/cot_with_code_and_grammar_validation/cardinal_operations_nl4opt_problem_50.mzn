float: cat_available = 20.0;
float: shark_available = 50.0;

float: cat_frac_mix1 = 0.20;
float: shark_frac_mix1 = 0.80;

float: cat_frac_mix2 = 0.35;
float: shark_frac_mix2 = 0.65;

float: profit_mix1 = 12.0;
float: profit_mix2 = 15.0;

var 0.0..1.0e6: x1;
var 0.0..1.0e6: x2;

constraint cat_frac_mix1 * x1 + cat_frac_mix2 * x2 <= cat_available;
constraint shark_frac_mix1 * x1 + shark_frac_mix2 * x2 <= shark_available;

var float: profit = profit_mix1 * x1 + profit_mix2 * x2;
solve maximize profit;

output [
  "x1 (kg mix 1) = ", show(x1), "\n",
  "x2 (kg mix 2) = ", show(x2), "\n",
  "profit = ", show(profit), "\n"
];