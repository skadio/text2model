int: min_hardwood = 20000;
int: min_vinyl = 10000;
int: min_total = 60000;
int: max_hardwood = 50000;
int: max_vinyl = 30000;

float: profit_hardwood = 2.5;
float: profit_vinyl = 3.0;

var min_hardwood..max_hardwood: hardwood;
var min_vinyl..max_vinyl: vinyl;

constraint hardwood + vinyl >= min_total;

var float: total_profit = profit_hardwood * int2float(hardwood) + profit_vinyl * int2float(vinyl);

solve maximize total_profit;

output [
  "hardwood=", show(hardwood), "\n",
  "vinyl=", show(vinyl), "\n",
  "profit=", show(total_profit), "\n"
];