% Parameters (with values embedded)
int: total_land = 500;
int: fuel_available = 9000;
int: waste_limit = 6000;

int: tea_trad = 30;
int: waste_trad = 10;
int: fuel_trad = 20;

int: tea_mod = 40;
int: waste_mod = 15;
int: fuel_mod = 15;

% Variables
var 0..total_land: acres_traditional;
var 0..total_land: acres_modern;
var 0..(tea_mod * total_land): total_tea;

% Constraints
constraint acres_traditional + acres_modern <= total_land;

constraint fuel_trad * acres_traditional + fuel_mod * acres_modern <= fuel_available;

constraint waste_trad * acres_traditional + waste_mod * acres_modern <= waste_limit;

constraint total_tea = tea_trad * acres_traditional + tea_mod * acres_modern;

% Objective
solve maximize total_tea;