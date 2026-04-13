% Parameters
int: profit_regular = 5000;
int: profit_premium = 8500;

int: max_regular_demand = 8;
int: max_premium_demand = 6;
int: max_total_cars = 12;

% Variables
var 0..max_regular_demand: x1;   % regular cars per day
var 0..max_premium_demand: x2;   % premium cars per day
var 0..(profit_regular*max_regular_demand + profit_premium*max_premium_demand): total_profit;

% Constraints
constraint x1 + x2 <= max_total_cars;

constraint total_profit = profit_regular * x1 + profit_premium * x2;

% Objective
solve maximize total_profit;