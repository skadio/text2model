% Parameters
int: plastic_available = 1000;
int: solder_available  = 250;

int: plastic_mech = 5;
int: solder_mech  = 2;

int: plastic_std = 2;
int: solder_std  = 1;

int: min_std = 30;
int: mech_to_std_ratio = 5;

% Variables
var 0..(plastic_available div plastic_mech): mech;
var 0..(plastic_available div plastic_std): std;

var 0..(plastic_available div 1): total_keyboards;

% Constraints
constraint total_keyboards = mech + std;

constraint plastic_mech * mech + plastic_std * std <= plastic_available;
constraint solder_mech  * mech + solder_std  * std <= solder_available;

constraint std >= min_std;
constraint mech = mech_to_std_ratio * std;

% Objective
solve maximize total_keyboards;