% Parameters (with values embedded)
int: max_total_reduction = 1000;
int: min_priority_diff = 200;
int: balance_target = 400;
int: cost_CO2 = 4;
int: cost_CH4 = 3;

% Variables
var 0..max_total_reduction: x_CO2;   % CO2 reduction (integer units)
var 0..max_total_reduction: y_CH4;   % Methane reduction (integer units)

% Constraints
constraint x_CO2 + y_CH4 <= max_total_reduction;
constraint 2 * x_CO2 - y_CH4 >= min_priority_diff;

% Balanced approach: (1/2)*x_CO2 + y_CH4 = 400  ->  x_CO2 + 2*y_CH4 = 800
constraint x_CO2 + 2 * y_CH4 = 2 * balance_target;

% Objective
solve minimize cost_CO2 * x_CO2 + cost_CH4 * y_CH4;