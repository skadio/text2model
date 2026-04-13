% Hay processing optimization (all data embedded)

% Parameters
int: total_acres = 200;

int: hay_windrower = 10;   % kg hay per acre
int: hay_harvester = 8;

int: methane_windrower = 5; % kg methane per acre
int: methane_harvester = 3;

int: fuel_windrower = 2;    % kg fuel per acre
int: fuel_harvester = 1;

int: fuel_available = 300;  % kg
int: methane_max = 800;     % kg

% Decision variables: acres assigned to each machine
var 0..total_acres: acres_w;
var 0..total_acres: acres_h;

% Constraints
constraint acres_w + acres_h <= total_acres;
constraint fuel_windrower * acres_w + fuel_harvester * acres_h <= fuel_available;
constraint methane_windrower * acres_w + methane_harvester * acres_h <= methane_max;

% Objective: maximize total hay processed
var int: total_hay = hay_windrower * acres_w + hay_harvester * acres_h;

solve maximize total_hay;

output [
  "Acres windrower = ", show(acres_w), "\n",
  "Acres harvester = ", show(acres_h), "\n",
  "Total hay (kg) = ", show(total_hay), "\n",
  "Fuel used (kg) = ", show(fuel_windrower * acres_w + fuel_harvester * acres_h), "\n",
  "Methane produced (kg) = ", show(methane_windrower * acres_w + methane_harvester * acres_h), "\n"
];