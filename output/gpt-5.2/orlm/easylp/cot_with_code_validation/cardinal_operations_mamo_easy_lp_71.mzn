% Parameters
int: total_acres = 100;
int: profit_wheat = 20;
int: profit_corn = 30;
int: demand_wheat_coeff = 3;
int: demand_corn_coeff = 2;
int: min_demand_units = 200;

% Variables
var 0..total_acres: acres_wheat;
var 0..total_acres: acres_corn;
var 0..(profit_wheat * total_acres + profit_corn * total_acres): total_profit;

% Constraints
constraint acres_wheat + acres_corn <= total_acres;

constraint demand_wheat_coeff * acres_wheat + demand_corn_coeff * acres_corn >= min_demand_units;

constraint total_profit = profit_wheat * acres_wheat + profit_corn * acres_corn;

% Objective
solve maximize total_profit;