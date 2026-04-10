% Parameters
int: cost_personal = 550;
int: cost_commercial = 2000;
int: profit_personal = 450;
int: profit_commercial = 1200;
int: max_licenses_total = 300;
int: max_budget = 400000;

% Variables
var 0..max_licenses_total: x_personal;
var 0..max_licenses_total: x_commercial;
var 0..(profit_personal * max_licenses_total + profit_commercial * max_licenses_total): total_profit;

% Constraints
constraint x_personal + x_commercial <= max_licenses_total;
constraint cost_personal * x_personal + cost_commercial * x_commercial <= max_budget;

constraint total_profit = profit_personal * x_personal + profit_commercial * x_commercial;

% Objective
solve maximize total_profit;