% Parameters (with values embedded)
int: plastic_available = 1000;
int: solder_available  = 250;

int: plastic_mech = 5;
int: solder_mech  = 2;

int: plastic_std = 2;
int: solder_std  = 1;

int: min_standard = 30;
int: mech_to_std_ratio = 5;

% Variables
var 0..plastic_available div plastic_mech: mechanical;
var min_standard..plastic_available div plastic_std: standard;
var 0..(plastic_available div min(plastic_mech, plastic_std)): total_keyboards;

% Constraints
constraint plastic_mech * mechanical + plastic_std * standard <= plastic_available;
constraint solder_mech  * mechanical + solder_std  * standard <= solder_available;

% five times as many mechanical as standard
constraint mechanical = mech_to_std_ratio * standard;

% define objective expression variable
constraint total_keyboards = mechanical + standard;

% Objective
solve maximize total_keyboards;