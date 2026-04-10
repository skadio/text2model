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
float: meaties_cap = 90000.0;

var 0.0..meaties_cap: x_meaties;
var 0.0..(grains_avail / grains_per_yummies): x_yummies;

var 0.0..grains_avail: grains_used;
var 0.0..meat_avail: meat_used;

var -1.0e12..1.0e12: profit;

constraint grains_used = grains_per_meaties * x_meaties + grains_per_yummies * x_yummies;
constraint meat_used = meat_per_meaties * x_meaties + meat_per_yummies * x_yummies;

constraint grains_used <= grains_avail;
constraint meat_used <= meat_avail;

constraint profit =
  (price_meaties - varcost_meaties) * x_meaties +
  (price_yummies - varcost_yummies) * x_yummies
  - grains_cost * grains_used
  - meat_cost * meat_used;

solve maximize profit;

output [
  "Meaties packs = ", show(x_meaties), "\n",
  "Yummies packs = ", show(x_yummies), "\n",
  "Grains used   = ", show(grains_used), "\n",
  "Meat used     = ", show(meat_used), "\n",
  "Profit        = ", show(profit), "\n"
];