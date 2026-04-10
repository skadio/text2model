% Parameters
int: min_total_budget = 1000;
int: max_weighted_budget = 5000;
int: min_digital_priority = 200;

int: cost_online = 5;
int: cost_offline = 10;

% Variables
var 0..max_weighted_budget: Online_Advertising;
var 0..max_weighted_budget: Offline_Marketing;

var 0..(cost_online*max_weighted_budget + cost_offline*max_weighted_budget): TotalCost;

% Constraints
constraint
  Online_Advertising + Offline_Marketing >= min_total_budget;

constraint
  2 * Online_Advertising + Offline_Marketing <= max_weighted_budget;

% Multiply by 2 to avoid fractions: Online - 0.5*Offline >= 200  <=>  2*Online - Offline >= 400
constraint
  2 * Online_Advertising - Offline_Marketing >= 2 * min_digital_priority;

constraint
  TotalCost = cost_online * Online_Advertising + cost_offline * Offline_Marketing;

% Objective
solve minimize TotalCost;