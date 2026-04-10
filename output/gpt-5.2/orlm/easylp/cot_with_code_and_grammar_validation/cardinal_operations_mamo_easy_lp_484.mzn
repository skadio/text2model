% Parameters
int: cost_CO2 = 4;
int: cost_CH4 = 3;

int: max_total_reduction = 1000;
int: min_priority_diff = 200;          % 2*CO2 - CH4 >= 200
int: balance_total = 400;              % 0.5*CO2 + CH4 = 400  ->  CO2 + 2*CH4 = 800

% Variables
var 0..max_total_reduction: CO2;
var 0..max_total_reduction: CH4;
var 0..(cost_CO2*max_total_reduction + cost_CH4*max_total_reduction): total_cost;

% Constraints
constraint CO2 + CH4 <= max_total_reduction;

constraint 2*CO2 - CH4 >= min_priority_diff;

% Avoid fractions: 0.5*CO2 + CH4 = 400  <=>  CO2 + 2*CH4 = 800
constraint CO2 + 2*CH4 = 2*balance_total;

constraint total_cost = cost_CO2*CO2 + cost_CH4*CH4;

% Objective
solve minimize total_cost;