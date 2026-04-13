% Parameters (with values embedded)
int: cost_premium = 2000;
int: profit_premium = 500;
int: cost_regular = 1000;
int: profit_regular = 300;

int: max_total_desktops = 200;
int: max_budget = 300000;

% Variables
var 0..max_total_desktops: premium;
var 0..max_total_desktops: regular;

% Constraints
constraint premium + regular <= max_total_desktops;
constraint cost_premium * premium + cost_regular * regular <= max_budget;

% Objective
var int: total_profit = profit_premium * premium + profit_regular * regular;
solve maximize total_profit;