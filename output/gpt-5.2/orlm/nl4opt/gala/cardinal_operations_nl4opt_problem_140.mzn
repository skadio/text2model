% Candy mix profit maximization (linear programming)

% Data (embedded)
float: reg_in_regmix = 0.8;
float: sour_in_regmix = 0.2;
float: reg_in_sourmix = 0.1;
float: sour_in_sourmix = 0.9;

float: profit_regmix = 3.0;
float: profit_sourmix = 5.0;

float: avail_reg = 80.0;
float: avail_sour = 60.0;

% Decision variables: kilograms produced of each mix
var 0.0..1.0e6: x; % regular mix (kg)
var 0.0..1.0e6: y; % sour surprise mix (kg)

% Resource constraints
constraint reg_in_regmix * x + reg_in_sourmix * y <= avail_reg;
constraint sour_in_regmix * x + sour_in_sourmix * y <= avail_sour;

% Objective: maximize profit
var float: total_profit = profit_regmix * x + profit_sourmix * y;

solve maximize total_profit;

output [
  "Regular mix (kg) = ", show(x), "\n",
  "Sour surprise mix (kg) = ", show(y), "\n",
  "Total profit ($) = ", show(total_profit), "\n",
  "Regular candy used (kg) = ", show(reg_in_regmix*x + reg_in_sourmix*y), " / ", show(avail_reg), "\n",
  "Sour candy used (kg) = ", show(sour_in_regmix*x + sour_in_sourmix*y), " / ", show(avail_sour), "\n"
];