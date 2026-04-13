% Parameters
int: water_avail = 2000;
int: alcohol_avail = 2100;

int: water_liquid = 40;
int: alcohol_liquid = 50;

int: water_foam = 60;
int: alcohol_foam = 40;

int: hands_liquid = 30;
int: hands_foam = 20;

int: max_liquid = 30;

% Variables
var 0..max_liquid: liquid;
var 0..water_avail div water_foam: foam;

var 0..(hands_liquid * max_liquid + hands_foam * (water_avail div water_foam)): total_hands;

% Constraints
constraint water_liquid * liquid + water_foam * foam <= water_avail;
constraint alcohol_liquid * liquid + alcohol_foam * foam <= alcohol_avail;

constraint foam >= liquid + 1;

constraint total_hands = hands_liquid * liquid + hands_foam * foam;

% Objective
solve maximize total_hands;