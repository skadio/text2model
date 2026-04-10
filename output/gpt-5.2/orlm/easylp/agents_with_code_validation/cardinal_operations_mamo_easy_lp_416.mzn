% Parameters
% All data is embedded directly in the model as per instructions.

int: min_total_budget = 1000;          % Minimum threshold for total budget
int: max_weighted_budget = 5000;       % Upper bound for 2*online + offline
int: min_digital_priority = 200;       % Lower bound for online - offline/2

int: online_unit_cost = 5;             % $ per unit of online advertising effectiveness
int: offline_unit_cost = 10;           % $ per unit of offline marketing effectiveness


% Variables
var 0..max_weighted_budget: online_advertising;   % Integer budget units for online advertising
var 0..max_weighted_budget: offline_marketing;    % Integer budget units for offline marketing

% Upper bound: cost if both were at max_weighted_budget (safe, not tight)
var 0..(online_unit_cost*max_weighted_budget + offline_unit_cost*max_weighted_budget): total_cost;


% Constraints

% --- Total budget minimum threshold ---
constraint
  online_advertising + offline_marketing >= min_total_budget;

% --- Overall resource constraint on weighted combination ---
constraint
  2 * online_advertising + offline_marketing <= max_weighted_budget;

% --- Digital priority constraint: online - (offline/2) >= 200 ---
% Avoid fractional arithmetic by multiplying both sides by 2:
% 2*online - offline >= 2*min_digital_priority
constraint
  2 * online_advertising - offline_marketing >= 2 * min_digital_priority;

% --- Total cost definition ---
constraint
  total_cost = online_unit_cost * online_advertising
             + offline_unit_cost * offline_marketing;


% Objective
solve minimize total_cost;

output [
  "online_advertising = ", show(online_advertising), "\n",
  "offline_marketing = ", show(offline_marketing), "\n",
  "total_cost = ", show(total_cost), "\n"
];