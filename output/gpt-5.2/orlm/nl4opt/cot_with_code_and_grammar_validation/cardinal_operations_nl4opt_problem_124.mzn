% Parameters
int: gems_required = 800;
int: water_available = 700;

int: gems_high = 50;
int: water_high = 50;

int: gems_low = 30;
int: water_low = 20;

float: max_high_fraction = 0.40;
int: min_low_drills = 10;

% Variables
var 0..gems_required: high_drills;
var 0..gems_required: low_drills;

var 0..2 * gems_required: total_drills;

% Constraints
constraint total_drills = high_drills + low_drills;

constraint gems_high * high_drills + gems_low * low_drills >= gems_required;

constraint water_high * high_drills + water_low * low_drills <= water_available;

constraint low_drills >= min_low_drills;

% At most 40% of drills are high intensity: high_drills <= 0.4 * total_drills
constraint 10 * high_drills <= 4 * total_drills;

% Objective
solve minimize total_drills;