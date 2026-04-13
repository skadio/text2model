% Marketing budget allocation (integer decision variables)
% Data embedded per instructions

int: min_total_budget = 1000;
int: max_weighted_effort = 5000;     % 2*Online + Offline <= 5000
int: min_digital_priority = 200;     % Online - Offline/2 >= 200

int: cost_online = 5;
int: cost_offline = 10;

% Safe upper bounds derived from constraints:
% Online + Offline >= 1000 and both nonnegative.
% 2*Online + Offline <= 5000 implies Online <= 2500, Offline <= 5000.
var 0..2500: Online_Advertising;
var 0..5000: Offline_Marketing;

% Constraints
constraint Online_Advertising + Offline_Marketing >= min_total_budget;
constraint 2 * Online_Advertising + Offline_Marketing <= max_weighted_effort;

% Use integer form to avoid fractions:
% Online - Offline/2 >= 200  <=>  2*Online - Offline >= 400
constraint 2 * Online_Advertising - Offline_Marketing >= 2 * min_digital_priority;

% Objective: minimize total cost in dollars
var int: TotalCost = cost_online * Online_Advertising + cost_offline * Offline_Marketing;

solve minimize TotalCost;

output [
  "Online_Advertising = ", show(Online_Advertising), "\n",
  "Offline_Marketing  = ", show(Offline_Marketing), "\n",
  "Minimum total cost ($) = ", show(TotalCost), "\n"
];