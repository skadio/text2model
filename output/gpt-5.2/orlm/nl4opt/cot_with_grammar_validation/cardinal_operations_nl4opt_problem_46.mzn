% Parameters
int: land = 500;
int: fuel_avail = 9000;
int: waste_max = 6000;

int: tea_trad = 30;
int: waste_trad = 10;
int: fuel_trad = 20;

int: tea_mod = 40;
int: waste_mod = 15;
int: fuel_mod = 15;

% Variables
var 0..land: acres_trad;
var 0..land: acres_mod;
var 0..(tea_trad * land + tea_mod * land): total_tea;

% Constraints
constraint acres_trad + acres_mod <= land;

constraint fuel_trad * acres_trad + fuel_mod * acres_mod <= fuel_avail;

constraint waste_trad * acres_trad + waste_mod * acres_mod <= waste_max;

constraint total_tea = tea_trad * acres_trad + tea_mod * acres_mod;

% Objective
solve maximize total_tea;