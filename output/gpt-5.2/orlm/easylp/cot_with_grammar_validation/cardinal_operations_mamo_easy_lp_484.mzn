% Parameters
int: max_total_reduction = 1000;
int: min_priority_diff = 200;          % 2*CO2 - Methane >= 200
int: target_balance = 400;             % (CO2/2) + Methane = 400
int: cost_co2 = 4;
int: cost_methane = 3;

% Variables
var 0..max_total_reduction: co2;
var 0..max_total_reduction: methane;
var 0..(cost_co2*max_total_reduction + cost_methane*max_total_reduction): total_cost;

% Constraints
constraint co2 + methane <= max_total_reduction;
constraint 2 * co2 - methane >= min_priority_diff;
constraint co2 + 2 * methane = 2 * target_balance;   % avoids fractions
constraint total_cost = cost_co2 * co2 + cost_methane * methane;

% Objective
solve minimize total_cost;