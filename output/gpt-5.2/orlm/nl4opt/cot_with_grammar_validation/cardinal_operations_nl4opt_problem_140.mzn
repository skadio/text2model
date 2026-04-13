float: reg_per_regmix = 0.8;
float: sour_per_regmix = 0.2;
float: reg_per_sourmix = 0.1;
float: sour_per_sourmix = 0.9;

float: profit_regmix = 3.0;
float: profit_sourmix = 5.0;

float: avail_reg = 80.0;
float: avail_sour = 60.0;

float: ub_regmix = min(avail_reg / reg_per_regmix, avail_sour / sour_per_regmix);
float: ub_sourmix = min(avail_reg / reg_per_sourmix, avail_sour / sour_per_sourmix);

var float: x_regmix;
var float: x_sourmix;

constraint x_regmix >= 0.0;
constraint x_regmix <= ub_regmix;
constraint x_sourmix >= 0.0;
constraint x_sourmix <= ub_sourmix;

constraint reg_per_regmix * x_regmix + reg_per_sourmix * x_sourmix <= avail_reg;
constraint sour_per_regmix * x_regmix + sour_per_sourmix * x_sourmix <= avail_sour;

solve maximize profit_regmix * x_regmix + profit_sourmix * x_sourmix;

output [
  "x_regmix=", show(x_regmix), "\n",
  "x_sourmix=", show(x_sourmix), "\n",
  "profit=", show(profit_regmix * x_regmix + profit_sourmix * x_sourmix), "\n"
];