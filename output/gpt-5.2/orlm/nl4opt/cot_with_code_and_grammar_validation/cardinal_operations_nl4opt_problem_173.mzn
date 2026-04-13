% Parameters
int: cost_premium = 2000;
int: profit_premium = 500;
int: cost_regular = 1000;
int: profit_regular = 300;

int: max_units = 200;
int: max_budget = 300000;

% Variables
var 0..max_units: premium;
var 0..max_units: regular;
var int: total_profit;

% Constraints
constraint premium + regular <= max_units;
constraint cost_premium * premium + cost_regular * regular <= max_budget;

constraint total_profit = profit_premium * premium + profit_regular * regular;

% Objective
solve maximize total_profit;