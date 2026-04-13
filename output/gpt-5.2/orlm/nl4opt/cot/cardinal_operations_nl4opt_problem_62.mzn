% Parameters (with values embedded)
int: profit_regular = 30;
int: profit_premium = 180;
int: cost_regular = 200;
int: cost_premium = 447;
int: budget = 250000;
int: max_total_bags = 475;

% Variables
var 0..max_total_bags: regular;
var 0..max_total_bags: premium;

% Constraints
constraint cost_regular * regular + cost_premium * premium <= budget;
constraint regular + premium <= max_total_bags;

% Objective
var int: total_profit = profit_regular * regular + profit_premium * premium;
solve maximize total_profit;