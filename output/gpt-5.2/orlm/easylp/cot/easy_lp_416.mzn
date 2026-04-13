% Parameters (with values embedded)
int: min_total_budget = 1000;
int: max_resource = 5000;
int: min_digital_priority = 200;

int: cost_online = 5;
int: cost_offline = 10;

% Variables
var 0..5000: Online_Advertising;
var 0..5000: Offline_Marketing;

% Constraints
constraint Online_Advertising + Offline_Marketing >= min_total_budget;
constraint 2 * Online_Advertising + Offline_Marketing <= max_resource;
constraint 2 * Online_Advertising - Offline_Marketing >= 2 * min_digital_priority;

% Objective
var int: Total_Cost = cost_online * Online_Advertising + cost_offline * Offline_Marketing;
solve minimize Total_Cost;