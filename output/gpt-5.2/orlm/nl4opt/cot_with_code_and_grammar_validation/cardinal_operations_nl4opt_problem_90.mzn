% Parameters
int: profit_regular = 5000;
int: profit_premium = 8500;
int: demand_regular_max = 8;
int: demand_premium_max = 6;
int: total_cars_max = 12;

% Variables
var 0..demand_regular_max: x1; % regular cars per day
var 0..demand_premium_max: x2; % premium cars per day

% Constraints
constraint x1 + x2 <= total_cars_max;

% Objective
solve maximize profit_regular * x1 + profit_premium * x2;