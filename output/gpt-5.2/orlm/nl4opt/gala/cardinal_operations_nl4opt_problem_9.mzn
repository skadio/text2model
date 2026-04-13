% Pharmaceutical paste production using small/large containers
% Maximize total paste subject to water and powdered pill availability.

include "globals.mzn";

% Data (embedded as required)
int: water_avail = 500;
int: powder_avail = 700;

int: water_small = 10;
int: powder_small = 15;
int: paste_small = 20;

int: water_large = 20;
int: powder_large = 20;
int: paste_large = 30;

% Decision variables: number of each container (nonnegative integers)
var 0..water_avail div min(water_small, water_large): nSmall;
var 0..water_avail div min(water_small, water_large): nLarge;

% Resource constraints
constraint water_small * nSmall + water_large * nLarge <= water_avail;
constraint powder_small * nSmall + powder_large * nLarge <= powder_avail;

% Objective: maximize total paste
var 0..(paste_small * (water_avail div water_small) + paste_large * (water_avail div water_large)): totalPaste;
constraint totalPaste = paste_small * nSmall + paste_large * nLarge;

solve maximize totalPaste;

output [
  "Small containers = ", show(nSmall), "\n",
  "Large containers = ", show(nLarge), "\n",
  "Total paste = ", show(totalPaste), "\n",
  "Water used = ", show(water_small*nSmall + water_large*nLarge), " / ", show(water_avail), "\n",
  "Powder used = ", show(powder_small*nSmall + powder_large*nLarge), " / ", show(powder_avail), "\n"
];