% Parameters (with values embedded)
int: budget = 500;                 % dollars available to spend
float: cost_carrot = 0.30;
float: cost_cucumber = 0.50;
float: profit_carrot = 0.75;
float: profit_cucumber = 0.80;

int: min_carrots = 300;
int: max_carrots = 500;

% Variables
var min_carrots..max_carrots: carrots;
var 0..10000: cucumbers;           % explicit upper bound; further restricted by constraints

% Constraints
constraint
  cost_carrot * int2float(carrots) + cost_cucumber * int2float(cucumbers) <= int2float(budget);

constraint
  3 * cucumbers <= carrots;

% Objective
var float: total_profit = profit_carrot * int2float(carrots) + profit_cucumber * int2float(cucumbers);

solve maximize total_profit;