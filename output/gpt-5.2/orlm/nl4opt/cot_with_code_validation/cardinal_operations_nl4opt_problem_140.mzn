% Candy mix optimization (LP)
% Data embedded as per problem statement

float: reg_in_regmix = 0.8;
float: sour_in_regmix = 0.2;
float: reg_in_sourmix = 0.1;
float: sour_in_sourmix = 0.9;

float: profit_regmix = 3.0;
float: profit_sourmix = 5.0;

float: avail_reg = 80.0;
float: avail_sour = 60.0;

% Upper bounds tightened to avoid search/timeouts:
% From regular constraint: x_regmix <= 80/0.8 = 100, x_sourmix <= 80/0.1 = 800
% From sour constraint:    x_regmix <= 60/0.2 = 300, x_sourmix <= 60/0.9 ≈ 66.666...
% So safe bounds: x_regmix <= 100, x_sourmix <= 66.666...

var 0.0..100.0: x_regmix;         % kg of regular mix
var 0.0..66.6666667: x_sourmix;   % kg of sour surprise mix

constraint reg_in_regmix * x_regmix + reg_in_sourmix * x_sourmix <= avail_reg;
constraint sour_in_regmix * x_regmix + sour_in_sourmix * x_sourmix <= avail_sour;

var float: total_profit = profit_regmix * x_regmix + profit_sourmix * x_sourmix;

solve maximize total_profit;

output [
  "x_regmix = ", show(x_regmix), "\n",
  "x_sourmix = ", show(x_sourmix), "\n",
  "total_profit = ", show(total_profit), "\n"
];