% Parameters
int: drops_motion = 50;
int: drops_manual = 75;
int: kwh_motion = 30;
int: kwh_manual = 20;

int: min_total_drops = 1000;
int: max_total_kwh = 500;

int: min_motion = 3;

% At most 40% manual: manual <= 0.4*(motion+manual)  <=>  3*manual <= 2*motion
int: manual_ratio_lhs = 3;
int: manual_ratio_rhs = 2;

% Safe upper bounds from kWh limit (nonnegative integers)
int: max_motion = max_total_kwh div kwh_motion; % 16
int: max_manual = max_total_kwh div kwh_manual; % 25

% Variables
var 0..max_motion: motion;
var 0..max_manual: manual;

var 0..(max_motion + max_manual): total_machines;

% Constraints
constraint total_machines = motion + manual;

constraint motion >= min_motion;

constraint drops_motion * motion + drops_manual * manual >= min_total_drops;

constraint kwh_motion * motion + kwh_manual * manual <= max_total_kwh;

constraint manual_ratio_lhs * manual <= manual_ratio_rhs * motion;

% Objective
solve minimize total_machines;