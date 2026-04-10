int: budget = 500;              % dollars available to buy produce

float: cost_carrot = 0.30;
float: cost_cucumber = 0.50;

float: profit_carrot = 0.75;
float: profit_cucumber = 0.80;

int: min_carrots = 300;
int: max_carrots = 500;

var min_carrots..max_carrots: carrots;
var 0..max_carrots: cucumbers;  % safe upper bound

constraint
  cost_carrot * int2float(carrots) + cost_cucumber * int2float(cucumbers) <= budget;

constraint
  3 * cucumbers <= carrots;     % cucumbers at most one third of carrots

var float: total_profit =
  profit_carrot * int2float(carrots) + profit_cucumber * int2float(cucumbers);

solve maximize total_profit;

output [
  "carrots = ", show(carrots), "\n",
  "cucumbers = ", show(cucumbers), "\n",
  "profit = ", show(total_profit), "\n"
];