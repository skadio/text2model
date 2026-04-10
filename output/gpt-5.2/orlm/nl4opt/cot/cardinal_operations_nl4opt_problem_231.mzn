% Parameters (with values embedded)
int: cost_personal = 550;
int: cost_commercial = 2000;
int: profit_personal = 450;
int: profit_commercial = 1200;
int: max_total_licenses = 300;
int: max_budget = 400000;

% Variables
var 0..max_total_licenses: x_personal;
var 0..max_total_licenses: x_commercial;
var 0..max_budget: total_cost;
var 0..(profit_personal*max_total_licenses + profit_commercial*max_total_licenses): total_profit;

% Constraints
constraint x_personal + x_commercial <= max_total_licenses;

constraint total_cost = cost_personal * x_personal + cost_commercial * x_commercial;
constraint total_cost <= max_budget;

constraint total_profit = profit_personal * x_personal + profit_commercial * x_commercial;

% Objective
solve maximize total_profit;