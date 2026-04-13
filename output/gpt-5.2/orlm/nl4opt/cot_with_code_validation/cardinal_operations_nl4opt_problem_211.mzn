% Parameters
int: plastic_available = 1000;
int: solder_available  = 250;

int: plastic_mech = 5;
int: solder_mech  = 2;

int: plastic_std = 2;
int: solder_std  = 1;

int: min_standard = 30;
int: mech_ratio   = 5;

% Variables
var 0..plastic_available div plastic_mech: mechanical;
var min_standard..plastic_available div plastic_std: standard;

% Constraints
constraint mechanical = mech_ratio * standard;

constraint plastic_mech * mechanical + plastic_std * standard <= plastic_available;
constraint solder_mech  * mechanical + solder_std  * standard <= solder_available;

% Objective
solve maximize mechanical + standard;