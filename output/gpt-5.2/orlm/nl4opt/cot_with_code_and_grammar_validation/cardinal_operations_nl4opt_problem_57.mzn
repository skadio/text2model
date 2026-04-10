% Parameters
int: water_per_liquid = 40;
int: alcohol_per_liquid = 50;
int: water_per_foam = 60;
int: alcohol_per_foam = 40;

int: water_available = 2000;
int: alcohol_available = 2100;

int: hands_per_liquid = 30;
int: hands_per_foam = 20;

int: liquid_max = 30;

% Variables
var 0..liquid_max: liquid;

% Upper bound for foam from resources (coarse, but valid):
% water: 60*foam <= 2000 -> foam <= 33
% alcohol: 40*foam <= 2100 -> foam <= 52
var 0..33: foam;

% Constraints
constraint
  water_per_liquid * liquid + water_per_foam * foam <= water_available;

constraint
  alcohol_per_liquid * liquid + alcohol_per_foam * foam <= alcohol_available;

constraint
  foam > liquid;

% Objective
solve maximize hands_per_liquid * liquid + hands_per_foam * foam;