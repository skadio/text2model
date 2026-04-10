% Parameters
int: max_desktops = 200;
int: budget = 300000;

int: cost_premium = 2000;
int: profit_premium = 500;

int: cost_regular = 1000;
int: profit_regular = 300;

% Variables
var 0..max_desktops: premium;
var 0..max_desktops: regular;
var 0..(profit_premium * max_desktops + profit_regular * max_desktops): total_profit;

% Constraints
constraint premium + regular <= max_desktops;
constraint cost_premium * premium + cost_regular * regular <= budget;
constraint total_profit = profit_premium * premium + profit_regular * regular;

% Objective
solve maximize total_profit;