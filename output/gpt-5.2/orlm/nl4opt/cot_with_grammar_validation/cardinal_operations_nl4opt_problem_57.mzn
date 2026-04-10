% Parameters
int: water_per_liquid = 40;
int: alcohol_per_liquid = 50;
int: water_per_foam = 60;
int: alcohol_per_foam = 40;

int: water_available = 2000;
int: alcohol_available = 2100;

int: hands_per_liquid = 30;
int: hands_per_foam = 20;

int: max_liquid = 30;

% Variables
var 0..max_liquid: liquid;
var 0..min(water_available div water_per_foam, alcohol_available div alcohol_per_foam): foam;

% Constraints
constraint
  water_per_liquid * liquid + water_per_foam * foam <= water_available;

constraint
  alcohol_per_liquid * liquid + alcohol_per_foam * foam <= alcohol_available;

constraint
  foam > liquid;

% Objective
solve maximize hands_per_liquid * liquid + hands_per_foam * foam;