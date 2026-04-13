% Parameters
% Maximum budget per channel
int: max_x1 = 5000;
int: max_x2 = 4000;
int: max_x3 = 3000;

% Maximum total budget across all channels
int: max_total_budget = 10000;

% Effectiveness constraint coefficients (scaled by 2 to avoid fractions)
% Original: 2*x1 - 3*x2 + 4.5*x3 >= 2000
% Scaled:   4*x1 - 6*x2 + 9*x3 >= 4000
int: eff_c1 = 4;
int: eff_c2 = -6;
int: eff_c3 = 9;
int: min_effectiveness_scaled = 4000;

% Balance constraint coefficients (scaled by 4 to avoid fractions)
% Original: (0.5*x2) - (x1 + 0.75*x3) <= 1500
% Scaled:   2*x2 - 4*x1 - 3*x3 <= 6000
int: bal_c1 = -4;
int: bal_c2 = 2;
int: bal_c3 = -3;
int: max_balance_scaled = 6000;

% Cost per unit budget for each channel
int: cost_x1 = 5000;
int: cost_x2 = 3000;
int: cost_x3 = 7000;


% Variables
% Budget allocated to each channel (integers, bounded by given per-channel maxima)
var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;

% Total cost in dollars (bounded using per-channel maxima)
var 0..(cost_x1*max_x1 + cost_x2*max_x2 + cost_x3*max_x3): total_cost;


% Constraints
% Total budget limit across all channels
constraint x1 + x2 + x3 <= max_total_budget;

% Minimum effectiveness requirement (scaled to keep all-integer arithmetic)
constraint eff_c1 * x1 + eff_c2 * x2 + eff_c3 * x3 >= min_effectiveness_scaled;

% Balance/exposure constraint (scaled to keep all-integer arithmetic)
constraint bal_c1 * x1 + bal_c2 * x2 + bal_c3 * x3 <= max_balance_scaled;

% Define total cost from channel budgets and unit costs
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;


% Objective
solve minimize total_cost;