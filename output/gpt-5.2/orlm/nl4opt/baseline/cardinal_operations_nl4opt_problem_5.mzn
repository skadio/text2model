int: min_hardwood = 20000;
int: min_vinyl    = 10000;

int: min_total = 60000;

int: max_hardwood = 50000;
int: max_vinyl    = 30000;

float: profit_hardwood = 2.5;
float: profit_vinyl    = 3.0;

var 0..max_hardwood: hardwood;
var 0..max_vinyl: vinyl;

constraint hardwood >= min_hardwood;
constraint vinyl    >= min_vinyl;
constraint hardwood + vinyl >= min_total;

var float: total_profit = profit_hardwood * hardwood + profit_vinyl * vinyl;

solve maximize total_profit;

output [
  "hardwood_sqft = ", show(hardwood), "\n",
  "vinyl_sqft = ", show(vinyl), "\n",
  "total_sqft = ", show(hardwood + vinyl), "\n",
  "profit = $", show(total_profit), "\n"
];