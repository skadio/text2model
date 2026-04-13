% Parameters
int: cost_personal = 550;
int: cost_commercial = 2000;
int: profit_personal = 450;
int: profit_commercial = 1200;
int: max_total_licenses = 300;
int: max_budget = 400000;

% Variables
var 0..max_total_licenses: personal;
var 0..max_total_licenses: commercial;
var 0..(profit_personal * max_total_licenses + profit_commercial * max_total_licenses): total_profit;

% Constraints
constraint personal + commercial <= max_total_licenses;
constraint cost_personal * personal + cost_commercial * commercial <= max_budget;
constraint total_profit = profit_personal * personal + profit_commercial * commercial;

% Objective
solve maximize total_profit;