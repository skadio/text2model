% Parameters
int: cost_co2 = 4;                 % cost per unit CO2 reduction
int: cost_methane = 3;             % cost per unit Methane reduction

int: max_total_reduction = 1000;   % upper bound on combined reductions

int: min_priority_gap = 200;       % lower bound for (2*CO2 - Methane)
int: balance_total = 400;          % target for (CO2/2 + Methane)

% Variables
var 0..max_total_reduction: co2_reduction;       % integer units of CO2 reduction
var 0..max_total_reduction: methane_reduction;   % integer units of Methane reduction

% Total cost (bounded using worst-case within the variable bounds)
var 0..(cost_co2*max_total_reduction + cost_methane*max_total_reduction): total_cost;

% Constraints
% --- Total cost definition (link decision variables to total_cost) ---
constraint
  total_cost = cost_co2 * co2_reduction + cost_methane * methane_reduction;

% --- Combined reduction capacity limit ---
constraint
  co2_reduction + methane_reduction <= max_total_reduction;

% --- Environmental priority constraint: (2*CO2 - Methane) at least min_priority_gap ---
constraint
  2 * co2_reduction - methane_reduction >= min_priority_gap;

% --- Balance constraint: (CO2/2 + Methane) equals balance_total ---
% To keep everything integral, multiply by 2: CO2 + 2*Methane = 2*balance_total
constraint
  co2_reduction + 2 * methane_reduction = 2 * balance_total;

% Objective
solve minimize total_cost;

% Optional output for inspection
output [
  "co2_reduction = ", show(co2_reduction), "\n",
  "methane_reduction = ", show(methane_reduction), "\n",
  "total_cost = ", show(total_cost), "\n"
];