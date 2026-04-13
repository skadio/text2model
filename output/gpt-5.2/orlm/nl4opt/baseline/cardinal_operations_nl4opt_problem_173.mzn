% Electronics store desktop production optimization

% Parameters (embedded data)
int: max_total_desktops = 200;
int: max_budget = 300000;

int: cost_premium = 2000;
int: cost_regular = 1000;

int: profit_premium = 500;
int: profit_regular = 300;

% Decision variables
var 0..max_total_desktops: premium;
var 0..max_total_desktops: regular;

% Constraints
constraint premium + regular <= max_total_desktops;
constraint cost_premium * premium + cost_regular * regular <= max_budget;

% Objective: maximize profit
var int: total_profit = profit_premium * premium + profit_regular * regular;
solve maximize total_profit;

output [
  "premium = ", show(premium), "\n",
  "regular = ", show(regular), "\n",
  "total_profit = ", show(total_profit), "\n",
  "total_cost = ", show(cost_premium * premium + cost_regular * regular), "\n",
  "total_units = ", show(premium + regular), "\n"
];