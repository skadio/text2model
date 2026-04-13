% Parameters
int: land = 500;
int: fuel_avail = 9000;
int: waste_max = 6000;

int: leaf_trad = 30;
int: waste_trad = 10;
int: fuel_trad = 20;

int: leaf_mod = 40;
int: waste_mod = 15;
int: fuel_mod = 15;

% Variables
var 0..land: acres_trad;
var 0..land: acres_mod;

% Constraints
constraint acres_trad + acres_mod <= land;

constraint fuel_trad * acres_trad + fuel_mod * acres_mod <= fuel_avail;

constraint waste_trad * acres_trad + waste_mod * acres_mod <= waste_max;

% Objective
solve maximize leaf_trad * acres_trad + leaf_mod * acres_mod;