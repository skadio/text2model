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
var 0..gems_required: x_high; % number of high intensity drills
var 0..gems_required: x_low;  % number of low intensity drills

var 0..2*gems_required: total_drills;

% Constraints
constraint total_drills = x_high + x_low;

constraint gems_high * x_high + gems_low * x_low >= gems_required;
constraint water_high * x_high + water_low * x_low <= water_available;

constraint x_low >= min_low_drills;

constraint x_high * 100 <= floor(max_high_fraction * 100.0) * total_drills;

% Objective
solve minimize total_drills;