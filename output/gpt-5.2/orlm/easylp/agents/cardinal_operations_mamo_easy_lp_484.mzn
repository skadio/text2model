% Parameters
% Cost per unit reduction
int: cost_co2 = 4;
int: cost_methane = 3;

% Limits/targets
int: max_total_reduction = 1000;     % CO2 + Methane <= 1000
int: priority_min = 200;             % 2*CO2 - Methane >= 200
int: balance_total = 400;            % (CO2 / 2) + Methane = 400


% Variables
% Integer units of reductions (whole numbers only)
var 0..max_total_reduction: co2_reduction;
var 0..max_total_reduction: methane_reduction;

% Total cost (upper bound sufficient for linear objective)
var 0..(cost_co2*max_total_reduction + cost_methane*max_total_reduction): total_cost;


% Constraints
% --- Total reduction capacity constraint ---
constraint co2_reduction + methane_reduction <= max_total_reduction;

% --- Environmental priority constraint (favor CO2) ---
constraint 2 * co2_reduction - methane_reduction >= priority_min;

% --- Balanced approach target constraint ---
% Multiply (CO2/2 + Methane = balance_total) by 2 to avoid fractional coefficient:
% co2_reduction + 2*methane_reduction = 2*balance_total
constraint co2_reduction + 2 * methane_reduction = 2 * balance_total;

% --- Define total cost from reductions ---
constraint total_cost = cost_co2 * co2_reduction + cost_methane * methane_reduction;


% Objective
solve minimize total_cost;