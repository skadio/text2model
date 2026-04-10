% Parameters
int: total_acres = 200;                 % Total available land (acres)

int: hay_windrower_per_acre = 10;       % kg hay processed per acre by windrower
int: hay_harvester_per_acre = 8;        % kg hay processed per acre by hay harvester

int: methane_windrower_per_acre = 5;    % kg methane produced per acre by windrower
int: methane_harvester_per_acre = 3;    % kg methane produced per acre by hay harvester
int: methane_max = 800;                 % Maximum allowed methane (kg)

int: fuel_windrower_per_acre = 2;       % kg fuel required per acre by windrower
int: fuel_harvester_per_acre = 1;       % kg fuel required per acre by hay harvester
int: fuel_available = 300;              % Available fuel (kg)

% Variables
var 0..total_acres: acres_windrower;    % Acres processed with windrower
var 0..total_acres: acres_harvester;    % Acres processed with hay harvester
var 0..(hay_windrower_per_acre*total_acres + hay_harvester_per_acre*total_acres): total_hay; % Total hay processed (kg)

% Constraints
% Land allocation: total acres used by both machines cannot exceed available land
constraint
  acres_windrower + acres_harvester <= total_acres;

% Fuel capacity: total fuel consumed by both machines must not exceed available fuel
constraint
  fuel_windrower_per_acre * acres_windrower
+ fuel_harvester_per_acre * acres_harvester
<= fuel_available;

% Methane limit: total methane produced by both machines must not exceed the maximum allowed
constraint
  methane_windrower_per_acre * acres_windrower
+ methane_harvester_per_acre * acres_harvester
<= methane_max;

% Total hay definition: compute total hay processed from the chosen land allocation
constraint
  total_hay =
    hay_windrower_per_acre * acres_windrower
  + hay_harvester_per_acre * acres_harvester;

% Objective
solve maximize total_hay;