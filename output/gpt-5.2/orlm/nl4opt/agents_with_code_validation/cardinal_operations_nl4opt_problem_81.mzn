% Parameters
int: total_acres = 200;                 % Total available acres
int: hay_per_acre_windrower = 10;       % kg hay processed per acre (windrower)
int: hay_per_acre_harvester = 8;        % kg hay processed per acre (hay harvester)

int: methane_per_acre_windrower = 5;    % kg methane produced per acre (windrower)
int: fuel_per_acre_windrower = 2;       % kg fuel required per acre (windrower)

int: methane_per_acre_harvester = 3;    % kg methane produced per acre (hay harvester)
int: fuel_per_acre_harvester = 1;       % kg fuel required per acre (hay harvester)

int: fuel_available = 300;              % Total fuel available (kg)
int: methane_limit = 800;               % Maximum methane allowed (kg)

% Variables
var 0..total_acres: acres_windrower;    % Acres processed with windrower
var 0..total_acres: acres_harvester;    % Acres processed with hay harvester

var 0..(hay_per_acre_windrower*total_acres + hay_per_acre_harvester*total_acres): total_hay;
% Total hay processed (kg)

% Constraints
% Land allocation: cannot process more acres than available
constraint acres_windrower + acres_harvester <= total_acres;

% Fuel availability: total fuel used by both machines cannot exceed supply
constraint
  fuel_per_acre_windrower * acres_windrower +
  fuel_per_acre_harvester * acres_harvester
  <= fuel_available;

% Methane cap: total methane produced cannot exceed the allowed limit
constraint
  methane_per_acre_windrower * acres_windrower +
  methane_per_acre_harvester * acres_harvester
  <= methane_limit;

% Total hay processed: define total_hay from the chosen acre allocations
constraint
  total_hay =
    hay_per_acre_windrower * acres_windrower +
    hay_per_acre_harvester * acres_harvester;

% Objective
solve maximize total_hay;

output [
  "acres_windrower = ", show(acres_windrower), "\n",
  "acres_harvester = ", show(acres_harvester), "\n",
  "total_hay = ", show(total_hay), " kg\n"
];