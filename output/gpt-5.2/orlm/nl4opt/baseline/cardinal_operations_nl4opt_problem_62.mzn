% Handbag production/profit maximization

int: profit_regular = 30;
int: profit_premium = 180;

int: cost_regular = 200;
int: cost_premium = 447;

int: budget = 250000;
int: max_total_bags = 475;

var 0..max_total_bags: regular;
var 0..max_total_bags: premium;

constraint cost_regular * regular + cost_premium * premium <= budget;
constraint regular + premium <= max_total_bags;

var int: total_profit = profit_regular * regular + profit_premium * premium;

solve maximize total_profit;

output [
  "regular = ", show(regular), "\n",
  "premium = ", show(premium), "\n",
  "total_profit = ", show(total_profit), "\n",
  "total_cost = ", show(cost_regular * regular + cost_premium * premium), "\n",
  "total_bags = ", show(regular + premium), "\n"
];