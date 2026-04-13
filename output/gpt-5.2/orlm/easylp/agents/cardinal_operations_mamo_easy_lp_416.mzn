% Parameters
int: min_total_budget = 1000;           % Minimum total budget threshold
int: max_resource_limit = 5000;         % Maximum for (2*online + offline)
int: min_digital_priority = 200;        % Minimum for (online - offline/2)

int: cost_per_unit_online = 5;          % $ cost per unit of online advertising
int: cost_per_unit_offline = 10;        % $ cost per unit of offline marketing


% Variables
var 0..max_resource_limit: Online_Advertising;  % Integer budget units for online advertising
var 0..max_resource_limit: Offline_Marketing;   % Integer budget units for offline marketing

% Upper bound on cost is achieved by maxing both decision variables.
var 0..(cost_per_unit_online*max_resource_limit + cost_per_unit_offline*max_resource_limit): Total_Cost;


% Constraints
% --- Total cost definition ---
constraint
  Total_Cost = cost_per_unit_online * Online_Advertising
             + cost_per_unit_offline * Offline_Marketing;

% --- Minimum total budget threshold ---
constraint
  Online_Advertising + Offline_Marketing >= min_total_budget;

% --- Overall resource constraint (2*online + offline) ---
constraint
  2 * Online_Advertising + Offline_Marketing <= max_resource_limit;

% --- Digital priority constraint: online - (offline/2) >= min_digital_priority ---
% Avoid fractional division by multiplying through by 2:
% 2*online - offline >= 2*min_digital_priority  <=>  online - offline/2 >= min_digital_priority
constraint
  2 * Online_Advertising - Offline_Marketing >= 2 * min_digital_priority;


% Objective
solve minimize Total_Cost;