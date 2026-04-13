% Parameters
int: total_acres = 100;
int: profit_wheat = 20;
int: profit_corn = 30;
int: wheat_coeff = 3;
int: corn_coeff = 2;
int: min_units = 200;

% Variables
var 0..total_acres: wheat_acres;
var 0..total_acres: corn_acres;

% Constraints
constraint wheat_acres + corn_acres <= total_acres;
constraint wheat_coeff * wheat_acres + corn_coeff * corn_acres >= min_units;

% Objective
var int: total_profit = profit_wheat * wheat_acres + profit_corn * corn_acres;
solve maximize total_profit;