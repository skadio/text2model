% Parameters
int: inj_north_per_hr = 800;
int: cream_north_per_hr = 700;
int: inj_west_per_hr  = 650;
int: cream_west_per_hr = 750;

int: plastic_north_per_hr = 40;
int: plastic_west_per_hr  = 35;
int: plastic_available = 60000;

int: inj_required = 800000;
int: cream_required = 700000;

% Variables
var 0..2000: hours_north;
var 0..2000: hours_west;

% Constraints
constraint
  inj_north_per_hr * hours_north + inj_west_per_hr * hours_west >= inj_required;

constraint
  cream_north_per_hr * hours_north + cream_west_per_hr * hours_west >= cream_required;

constraint
  plastic_north_per_hr * hours_north + plastic_west_per_hr * hours_west <= plastic_available;

% Objective
solve minimize hours_north + hours_west;