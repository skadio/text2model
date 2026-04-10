% Parameters
int: cost_premium = 2000;
int: profit_premium = 500;
int: cost_regular = 1000;
int: profit_regular = 300;
int: max_total_units = 200;
int: max_total_cost = 300000;

% Variables
var 0..max_total_units: premium;
var 0..max_total_units: regular;
var 0..(profit_premium * max_total_units + profit_regular * max_total_units): total_profit;

% Constraints
constraint premium + regular <= max_total_units;
constraint cost_premium * premium + cost_regular * regular <= max_total_cost;
constraint total_profit = profit_premium * premium + profit_regular * regular;

% Objective
solve maximize total_profit;