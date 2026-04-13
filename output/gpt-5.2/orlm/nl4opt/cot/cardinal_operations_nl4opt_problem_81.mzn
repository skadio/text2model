% Parameters (with values embedded)
int: total_acres = 200;

int: hay_per_acre_windrower = 10;
int: hay_per_acre_harvester = 8;

int: methane_per_acre_windrower = 5;
int: methane_per_acre_harvester = 3;
int: methane_max = 800;

int: fuel_per_acre_windrower = 2;
int: fuel_per_acre_harvester = 1;
int: fuel_available = 300;

% Variables
var 0..total_acres: acres_windrower;
var 0..total_acres: acres_harvester;

% Constraints
constraint acres_windrower + acres_harvester <= total_acres;

constraint fuel_per_acre_windrower * acres_windrower
         + fuel_per_acre_harvester * acres_harvester <= fuel_available;

constraint methane_per_acre_windrower * acres_windrower
         + methane_per_acre_harvester * acres_harvester <= methane_max;

% Objective
var 0..(hay_per_acre_windrower * total_acres): total_hay;
constraint total_hay = hay_per_acre_windrower * acres_windrower
                     + hay_per_acre_harvester * acres_harvester;

solve maximize total_hay;

output [
  "acres_windrower = ", show(acres_windrower), "\n",
  "acres_harvester = ", show(acres_harvester), "\n",
  "total_hay = ", show(total_hay), " kg\n"
];