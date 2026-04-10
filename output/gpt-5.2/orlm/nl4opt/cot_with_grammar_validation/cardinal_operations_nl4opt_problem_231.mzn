% Parameters
int: cost_personal = 550;
int: cost_commercial = 2000;
int: profit_personal = 450;
int: profit_commercial = 1200;
int: max_total_licenses = 300;
int: max_budget = 400000;

% Variables
var 0..max_total_licenses: x_personal;
var 0..max_total_licenses: x_commercial;

% Constraints
constraint x_personal + x_commercial <= max_total_licenses;
constraint cost_personal * x_personal + cost_commercial * x_commercial <= max_budget;

% Objective
var int: total_profit = profit_personal * x_personal + profit_commercial * x_commercial;
solve maximize total_profit;