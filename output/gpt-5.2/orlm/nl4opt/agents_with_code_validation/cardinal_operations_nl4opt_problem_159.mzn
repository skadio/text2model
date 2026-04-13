% Parameters
int: max_wired_per_day = 100;        % Maximum wired headphones the wired team can produce per day
int: max_wireless_per_day = 170;     % Maximum wireless headphones the wireless team can produce per day
int: max_tested_per_day = 150;       % Maximum total headphones that can be tested per day (shared machine)

int: profit_wired = 50;              % Profit per wired headphone
int: profit_wireless = 20;           % Profit per wireless headphone

% Variables
var 0..max_wired_per_day: wired_produced;         % Number of wired headphones produced
var 0..max_wireless_per_day: wireless_produced;   % Number of wireless headphones produced

% Constraints
% Shared audio testing machine capacity (both types require testing)
constraint
  wired_produced + wireless_produced <= max_tested_per_day;

% Objective
solve maximize profit_wired * wired_produced + profit_wireless * wireless_produced;