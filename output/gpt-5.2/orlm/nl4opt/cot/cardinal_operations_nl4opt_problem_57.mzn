% Parameters (with values embedded)
int: water_available = 2000;
int: alcohol_available = 2100;

int: water_liquid = 40;
int: alcohol_liquid = 50;

int: water_foam = 60;
int: alcohol_foam = 40;

int: clean_liquid = 30;
int: clean_foam = 20;

int: max_liquid = 30;

% Variables
var 0..max_liquid: liquid;
var 0..33: foam; % upper bound from water: 60*foam <= 2000 => foam <= 33

% Constraints
constraint water_liquid * liquid + water_foam * foam <= water_available;
constraint alcohol_liquid * liquid + alcohol_foam * foam <= alcohol_available;

constraint foam > liquid;

% Objective
solve maximize clean_liquid * liquid + clean_foam * foam;