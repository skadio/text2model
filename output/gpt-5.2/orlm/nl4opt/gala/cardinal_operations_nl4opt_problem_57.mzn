% Hand sanitizer production optimization (data embedded)

include "globals.mzn";

% Data
int: water_avail = 2000;
int: alcohol_avail = 2100;

int: water_liquid = 40;
int: alcohol_liquid = 50;

int: water_foam = 60;
int: alcohol_foam = 40;

int: hands_liquid = 30;
int: hands_foam = 20;

int: max_liquid = 30;

% Decision variables
var 0..max_liquid: liquid;
var 0..(water_avail div water_foam): foam; % safe upper bound from water

% Constraints
constraint water_liquid * liquid + water_foam * foam <= water_avail;
constraint alcohol_liquid * liquid + alcohol_foam * foam <= alcohol_avail;

constraint foam > liquid;
constraint liquid <= max_liquid;

% Objective: maximize hands cleaned
var int: total_hands = hands_liquid * liquid + hands_foam * foam;

solve maximize total_hands;

output [
  "liquid = ", show(liquid), "\n",
  "foam = ", show(foam), "\n",
  "total_hands = ", show(total_hands), "\n",
  "water_used = ", show(water_liquid * liquid + water_foam * foam), " / ", show(water_avail), "\n",
  "alcohol_used = ", show(alcohol_liquid * liquid + alcohol_foam * foam), " / ", show(alcohol_avail), "\n"
];