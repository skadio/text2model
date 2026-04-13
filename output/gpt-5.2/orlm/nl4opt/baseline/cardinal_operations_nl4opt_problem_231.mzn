% Platinum Database license production optimization

int: cost_personal = 550;
int: cost_commercial = 2000;

int: profit_personal = 450;
int: profit_commercial = 1200;

int: max_total_licenses = 300;
int: max_budget = 400000;

var 0..max_total_licenses: personal;
var 0..max_total_licenses: commercial;

constraint personal + commercial <= max_total_licenses;
constraint cost_personal * personal + cost_commercial * commercial <= max_budget;

var int: total_profit = profit_personal * personal + profit_commercial * commercial;

solve maximize total_profit;

output [
  "personal = ", show(personal), "\n",
  "commercial = ", show(commercial), "\n",
  "total_cost = ", show(cost_personal * personal + cost_commercial * commercial), "\n",
  "total_profit = ", show(total_profit), "\n"
];