% Parameters
% Minimum required effectiveness score
int: min_effectiveness = 50;

% Maximum allowed audience fatigue score
int: max_fatigue = 300;

% Effectiveness contribution per dollar for each ad channel (Ad1, Ad2)
array[1..2] of int: eff = [1, 1];

% Fatigue contribution per dollar for each ad channel (Ad1, Ad2)
array[1..2] of int: fatigue = [4, 6];

% Cost per dollar allocated to each ad channel (Ad1, Ad2)
array[1..2] of int: cost = [5, 3];

% Safe upper bounds for budgets (derived from fatigue constraint: 4*x1 + 6*x2 <= 300)
int: max_ad1_budget = max_fatigue div fatigue[1]; % 300 div 4 = 75
int: max_ad2_budget = max_fatigue div fatigue[2]; % 300 div 6 = 50


% Variables
% Budget allocated to Ad1 and Ad2 (whole dollars)
var 0..max_ad1_budget: ad1_budget;
var 0..max_ad2_budget: ad2_budget;

% Total cost to minimize (bounded by max possible spend within individual bounds)
var 0..(cost[1]*max_ad1_budget + cost[2]*max_ad2_budget): total_cost;


% Constraints
% ---- Effectiveness requirement: combined effectiveness must be at least the minimum ----
constraint
  eff[1] * ad1_budget + eff[2] * ad2_budget >= min_effectiveness;

% ---- Audience fatigue limit: weighted sum of budgets must not exceed maximum ----
constraint
  fatigue[1] * ad1_budget + fatigue[2] * ad2_budget <= max_fatigue;

% ---- Total cost definition: link total_cost to chosen budgets ----
constraint
  total_cost = cost[1] * ad1_budget + cost[2] * ad2_budget;


% Objective
solve minimize total_cost;