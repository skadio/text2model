% Parameters
int: profit_regular = 30;
int: profit_premium = 180;

int: cost_regular = 200;
int: cost_premium = 447;

int: budget = 250000;
int: max_total = 475;

% Variables
var 0..max_total: x_regular;
var 0..max_total: x_premium;
var 0..(profit_regular * max_total + profit_premium * max_total): total_profit;

% Constraints
constraint cost_regular * x_regular + cost_premium * x_premium <= budget;
constraint x_regular + x_premium <= max_total;
constraint total_profit = profit_regular * x_regular + profit_premium * x_premium;

% Objective
solve maximize total_profit;