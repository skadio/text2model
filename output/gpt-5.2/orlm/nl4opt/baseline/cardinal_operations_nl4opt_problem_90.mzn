% Car production optimization (regular vs premium)

int: profit_regular = 5000;
int: profit_premium = 8500;

int: max_demand_regular = 8;
int: max_demand_premium = 6;
int: max_total_cars = 12;

var 0..max_demand_regular: x1; % regular cars per day
var 0..max_demand_premium: x2; % premium cars per day

constraint x1 + x2 <= max_total_cars;

var int: total_profit = profit_regular * x1 + profit_premium * x2;

solve maximize total_profit;

output [
  "Regular (x1) = ", show(x1), "\n",
  "Premium (x2) = ", show(x2), "\n",
  "Total profit = $", show(total_profit), "\n"
];