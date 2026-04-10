% Parameters
int: total_acres = 200;

int: hay_per_acre_windrower = 10;
int: hay_per_acre_harvester = 8;

int: methane_per_acre_windrower = 5;
int: fuel_per_acre_windrower = 2;

int: methane_per_acre_harvester = 3;
int: fuel_per_acre_harvester = 1;

int: fuel_available = 300;
int: methane_max = 800;

% Variables
var 0..total_acres: acres_windrower;
var 0..total_acres: acres_harvester;

var 0..(hay_per_acre_windrower * total_acres): total_hay;

% Constraints
constraint acres_windrower + acres_harvester <= total_acres;

constraint fuel_per_acre_windrower * acres_windrower
         + fuel_per_acre_harvester * acres_harvester
         <= fuel_available;

constraint methane_per_acre_windrower * acres_windrower
         + methane_per_acre_harvester * acres_harvester
         <= methane_max;

constraint total_hay
         = hay_per_acre_windrower * acres_windrower
         + hay_per_acre_harvester * acres_harvester;

% Objective
solve maximize total_hay;