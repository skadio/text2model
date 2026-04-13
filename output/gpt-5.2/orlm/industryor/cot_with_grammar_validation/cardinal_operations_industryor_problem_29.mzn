int: nFeeds = 5;
set of int: FEEDS = 1..nFeeds;

float: reqProtein = 700.0;
float: reqMinerals = 30.0;
float: reqVitamins = 100.0;

array[FEEDS] of float: protein = [3.0, 2.0, 1.0, 6.0, 18.0];
array[FEEDS] of float: minerals = [1.0, 0.5, 0.2, 2.0, 0.5];
array[FEEDS] of float: vitamins = [0.5, 1.0, 0.2, 2.0, 0.8];
array[FEEDS] of float: price = [0.2, 0.7, 0.4, 0.3, 0.8];

array[FEEDS] of var 0.0..1.0e6: x;
var 0.0..1.0e12: totalCost;

constraint sum(i in FEEDS)(protein[i] * x[i]) >= reqProtein;
constraint sum(i in FEEDS)(minerals[i] * x[i]) >= reqMinerals;
constraint sum(i in FEEDS)(vitamins[i] * x[i]) >= reqVitamins;

constraint totalCost = sum(i in FEEDS)(price[i] * x[i]);

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "totalCost = ", show(totalCost), "\n"
];