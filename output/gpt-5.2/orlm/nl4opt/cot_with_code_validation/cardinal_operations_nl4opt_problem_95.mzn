% Parameters
int: tooth_total = 2000;
int: tooth_small = 10;
int: meat_small = 12;
int: tooth_large = 15;
int: meat_large = 15;
int: min_large = 30;

% Variables
var 0..(tooth_total div tooth_small): small;
var 0..(tooth_total div tooth_large): large;

% Constraints
constraint tooth_small * small + tooth_large * large <= tooth_total;

% at least 50% of bones are small: small >= 0.5*(small+large) <=> small >= large
constraint small >= large;

constraint large >= min_large;

% Objective
solve minimize meat_small * small + meat_large * large;