% Healthy Pet Foods - Profit Maximization (all data embedded)

% Parameters
float: price_meaties = 2.80;
float: price_yummies = 2.00;

float: grains_per_meaties = 2.0;
float: grains_per_yummies = 3.0;

float: meat_per_meaties = 3.0;
float: meat_per_yummies = 1.5;

float: varcost_meaties = 0.25;
float: varcost_yummies = 0.20;

float: grains_cost = 0.20;
float: meat_cost = 0.50;

float: grains_avail = 400000.0;
float: meat_avail = 300000.0;

int: meaties_capacity = 90000;

% Conservative upper bound for yummies from raw material limits
int: yummies_max = 200000;

% Decision variables (packs produced)
var 0..meaties_capacity: x_meaties;
var 0..yummies_max: x_yummies;

% Constraints (raw material availability)
constraint grains_per_meaties * int2float(x_meaties)
         + grains_per_yummies * int2float(x_yummies)
         <= grains_avail;

constraint meat_per_meaties * int2float(x_meaties)
         + meat_per_yummies * int2float(x_yummies)
         <= meat_avail;

% Objective: maximize profit = revenue - variable costs - raw material costs
var float: profit =
    (price_meaties - varcost_meaties) * int2float(x_meaties)
  + (price_yummies - varcost_yummies) * int2float(x_yummies)
  - grains_cost * (grains_per_meaties * int2float(x_meaties)
                 + grains_per_yummies * int2float(x_yummies))
  - meat_cost   * (meat_per_meaties * int2float(x_meaties)
                 + meat_per_yummies * int2float(x_yummies));

solve maximize profit;

output [
  "Meaties packs = ", show(x_meaties), "\n",
  "Yummies packs = ", show(x_yummies), "\n",
  "Profit = ", show(profit), "\n"
];