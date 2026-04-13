% Parameters
int: water_available = 500;
int: pill_available = 700;

int: water_small = 10;
int: pill_small  = 15;
int: paste_small = 20;

int: water_large = 20;
int: pill_large  = 20;
int: paste_large = 30;

% Variables
var 0..(water_available div water_small): x_small;
var 0..(water_available div water_large): x_large;

var 0..(paste_small * (water_available div water_small) + paste_large * (water_available div water_large)): total_paste;

% Constraints
constraint water_small * x_small + water_large * x_large <= water_available;
constraint pill_small * x_small + pill_large * x_large <= pill_available;

constraint total_paste = paste_small * x_small + paste_large * x_large;

% Objective
solve maximize total_paste;