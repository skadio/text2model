% Parameters
int: max_wired_per_day = 100;          % Capacity of wired team (units/day)
int: max_wireless_per_day = 170;       % Capacity of wireless team (units/day)
int: max_test_machine_per_day = 150;   % Shared testing machine capacity (units/day)
int: profit_wired = 50;                % Profit per wired headphone ($/unit)
int: profit_wireless = 20;             % Profit per wireless headphone ($/unit)

% Variables
var 0..max_wired_per_day: wired_units;         % Number of wired headphones produced per day
var 0..max_wireless_per_day: wireless_units;   % Number of wireless headphones produced per day

% Constraints
% Individual team capacity constraints (already enforced by domains, repeated for clarity)
constraint wired_units <= max_wired_per_day;
constraint wireless_units <= max_wireless_per_day;

% Shared testing machine capacity constraint
constraint wired_units + wireless_units <= max_test_machine_per_day;

% Objective
solve maximize profit_wired * wired_units + profit_wireless * wireless_units;