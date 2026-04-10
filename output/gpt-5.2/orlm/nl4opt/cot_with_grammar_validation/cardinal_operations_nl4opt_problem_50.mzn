float: cat_available = 20.0;
float: shark_available = 50.0;

float: cat_pct_mix1 = 0.20;
float: shark_pct_mix1 = 0.80;
float: cat_pct_mix2 = 0.35;
float: shark_pct_mix2 = 0.65;

float: profit_mix1 = 12.0;
float: profit_mix2 = 15.0;

var float: x1 >= 0.0;
var float: x2 >= 0.0;

constraint cat_pct_mix1 * x1 + cat_pct_mix2 * x2 <= cat_available;
constraint shark_pct_mix1 * x1 + shark_pct_mix2 * x2 <= shark_available;

solve maximize profit_mix1 * x1 + profit_mix2 * x2;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "profit = ", show(profit_mix1 * x1 + profit_mix2 * x2), "\n"
];