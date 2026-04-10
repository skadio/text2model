% Parameters
int: profit_regular = 5000;
int: profit_premium = 8500;

int: max_demand_regular = 8;
int: max_demand_premium = 6;
int: max_total_cars = 12;

% Variables
var 0..max_demand_regular: x1; % regular cars per day
var 0..max_demand_premium: x2; % premium cars per day

var 0..(profit_regular * max_demand_regular + profit_premium * max_demand_premium): total_profit;

% Constraints
constraint x1 + x2 <= max_total_cars;

constraint total_profit = profit_regular * x1 + profit_premium * x2;

% Objective
solve maximize total_profit;