% Parameters
int: wood_available = 300;
int: oxygen_available = 300;

int: wood_cat = 10;
int: oxygen_cat = 20;
int: co2_cat = 15;

int: wood_nocat = 15;
int: oxygen_nocat = 12;
int: co2_nocat = 18;

% Variables
var 0..(wood_available div wood_cat): x_cat;
var 0..(wood_available div wood_nocat): x_nocat;

var 0..(wood_available + oxygen_available): total_co2;

% Constraints
constraint wood_cat * x_cat + wood_nocat * x_nocat <= wood_available;
constraint oxygen_cat * x_cat + oxygen_nocat * x_nocat <= oxygen_available;

constraint total_co2 = co2_cat * x_cat + co2_nocat * x_nocat;

% Objective
solve maximize total_co2;