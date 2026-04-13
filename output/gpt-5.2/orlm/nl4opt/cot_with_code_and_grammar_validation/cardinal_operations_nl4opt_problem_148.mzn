% Parameters
int: inj_north_per_hour = 800;
int: cream_north_per_hour = 700;
int: inj_west_per_hour  = 650;
int: cream_west_per_hour = 750;

int: plastic_north_per_hour = 40;
int: plastic_west_per_hour  = 35;
int: plastic_available = 60000;

int: inj_required = 800000;
int: cream_required = 700000;

% Variables
var 0..2000: h_north;
var 0..2000: h_west;

% Constraints
constraint inj_north_per_hour * h_north + inj_west_per_hour * h_west >= inj_required;
constraint cream_north_per_hour * h_north + cream_west_per_hour * h_west >= cream_required;
constraint plastic_north_per_hour * h_north + plastic_west_per_hour * h_west <= plastic_available;

% Objective
solve minimize h_north + h_west;