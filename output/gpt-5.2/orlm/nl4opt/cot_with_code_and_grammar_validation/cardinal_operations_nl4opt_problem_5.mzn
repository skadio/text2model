float: profit_hardwood = 2.5;
float: profit_vinyl = 3.0;

int: demand_min_hardwood = 20000;
int: demand_min_vinyl = 10000;

int: ship_min_total = 60000;

int: capacity_max_hardwood = 50000;
int: capacity_max_vinyl = 30000;

var demand_min_hardwood..capacity_max_hardwood: hardwood;
var demand_min_vinyl..capacity_max_vinyl: vinyl;

constraint hardwood + vinyl >= ship_min_total;

var float: total_profit;
constraint total_profit = profit_hardwood * hardwood + profit_vinyl * vinyl;

solve maximize total_profit;

output [
  "hardwood = ", show(hardwood), "\n",
  "vinyl = ", show(vinyl), "\n",
  "total_profit = ", show(total_profit), "\n"
];