% Hay processing optimization (all data embedded)

int: total_acres = 200;

% Per-acre hay processed (kg)
int: hay_windrower = 10;
int: hay_harvester = 8;

% Per-acre methane produced (kg)
int: methane_windrower = 5;
int: methane_harvester = 3;

% Per-acre fuel required (kg)
int: fuel_windrower = 2;
int: fuel_harvester = 1;

int: fuel_available = 300;
int: methane_max = 800;

var 0..total_acres: acres_windrower;
var 0..total_acres: acres_harvester;

constraint acres_windrower + acres_harvester <= total_acres;
constraint fuel_windrower * acres_windrower + fuel_harvester * acres_harvester <= fuel_available;
constraint methane_windrower * acres_windrower + methane_harvester * acres_harvester <= methane_max;

var int: total_hay = hay_windrower * acres_windrower + hay_harvester * acres_harvester;

solve maximize total_hay;

output [
  "acres_windrower=", show(acres_windrower), "\n",
  "acres_harvester=", show(acres_harvester), "\n",
  "total_hay_kg=", show(total_hay), "\n",
  "fuel_used_kg=", show(fuel_windrower * acres_windrower + fuel_harvester * acres_harvester), "\n",
  "methane_kg=", show(methane_windrower * acres_windrower + methane_harvester * acres_harvester), "\n"
];