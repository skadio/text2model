% Emission reduction planning (CO2 and Methane)
% Minimize cost subject to linear constraints, with integer decisions.

int: max_total_reduction = 1000;
int: min_priority_diff = 200;     % 2*CO2 - Methane >= 200
int: balance_target = 400;        % 0.5*CO2 + Methane = 400

int: cost_co2 = 4;
int: cost_methane = 3;

% Decision variables (whole-number reductions)
var 0..max_total_reduction: co2;
var 0..max_total_reduction: methane;

% Constraints
constraint co2 + methane <= max_total_reduction;
constraint 2 * co2 - methane >= min_priority_diff;

% Avoid fractions by multiplying the balance equation by 2:
% 0.5*co2 + methane = 400  <=>  co2 + 2*methane = 800
constraint co2 + 2 * methane = 2 * balance_target;

% Objective: minimize total cost
var int: total_cost = cost_co2 * co2 + cost_methane * methane;
solve minimize total_cost;

output [
  "CO2_reduction = ", show(co2), "\n",
  "Methane_reduction = ", show(methane), "\n",
  "Minimum_total_cost (rounded) = ", show(total_cost), "\n"
];