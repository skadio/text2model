% Budget allocation optimization (all data embedded)

int: min_total_budget = 1000;
int: max_resource = 5000;
int: min_digital_priority = 200;

int: cost_online = 5;
int: cost_offline = 10;

% Decision variables (integer budgets)
var 0..100000: Online_Advertising;
var 0..100000: Offline_Marketing;

% Objective: minimize total cost
var int: TotalCost = cost_online * Online_Advertising + cost_offline * Offline_Marketing;

constraint Online_Advertising + Offline_Marketing >= min_total_budget;
constraint 2 * Online_Advertising + Offline_Marketing <= max_resource;
% Online_Advertising - (Offline_Marketing / 2) >= 200  ->  2*Online_Advertising - Offline_Marketing >= 400
constraint 2 * Online_Advertising - Offline_Marketing >= 2 * min_digital_priority;

solve minimize TotalCost;

output [
  "Online_Advertising = ", show(Online_Advertising), "\n",
  "Offline_Marketing = ", show(Offline_Marketing), "\n",
  "Minimum total cost ($) = ", show(TotalCost), "\n"
];