% Parameters
int: total_acres = 200;

int: hay_windrower_per_acre = 10;
int: hay_harvester_per_acre = 8;

int: methane_windrower_per_acre = 5;
int: methane_harvester_per_acre = 3;
int: methane_max = 800;

int: fuel_windrower_per_acre = 2;
int: fuel_harvester_per_acre = 1;
int: fuel_available = 300;

% Variables
var 0..total_acres: acres_windrower;
var 0..total_acres: acres_harvester;

var 0..(hay_windrower_per_acre*total_acres + hay_harvester_per_acre*total_acres): total_hay;

% Constraints
constraint acres_windrower + acres_harvester <= total_acres;

constraint fuel_windrower_per_acre * acres_windrower
         + fuel_harvester_per_acre * acres_harvester
         <= fuel_available;

constraint methane_windrower_per_acre * acres_windrower
         + methane_harvester_per_acre * acres_harvester
         <= methane_max;

constraint total_hay = hay_windrower_per_acre * acres_windrower
                     + hay_harvester_per_acre * acres_harvester;

% Objective
solve maximize total_hay;