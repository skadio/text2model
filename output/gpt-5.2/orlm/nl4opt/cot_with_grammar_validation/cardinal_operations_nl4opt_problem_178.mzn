% Parameters
int: drops_motion = 50;
int: drops_manual = 75;
int: kwh_motion = 30;
int: kwh_manual = 20;

int: min_total_drops = 1000;
int: max_total_kwh = 500;

int: min_motion = 3;
float: max_manual_fraction = 0.4;

% Variables
var 0..20: motion; % upper bound from 50*motion >= 1000 => motion >= 20 if manual=0
var 0..20: manual; % upper bound from 75*manual >= 1000 => manual >= 14, so 20 is safe

var 0..40: total_machines;

% Constraints
constraint motion >= min_motion;

constraint total_machines = motion + manual;

constraint drops_motion * motion + drops_manual * manual >= min_total_drops;

constraint kwh_motion * motion + kwh_manual * manual <= max_total_kwh;

% At most 40% manual: manual <= 0.4 * total_machines
% Use integer-safe form: 5*manual <= 2*total_machines
constraint 5 * manual <= 2 * total_machines;

% Objective
solve minimize total_machines;