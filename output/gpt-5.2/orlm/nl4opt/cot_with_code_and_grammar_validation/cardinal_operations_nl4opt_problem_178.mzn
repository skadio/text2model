% Parameters
int: drops_motion = 50;
int: drops_manual = 75;
int: kwh_motion = 30;
int: kwh_manual = 20;

int: min_drops = 1000;
int: max_kwh = 500;

int: min_motion = 3;

% Variables
var 0..1000: motion;
var 0..1000: manual;
var 0..2000: total;

% Constraints
constraint total = motion + manual;

% At most 40% manual: manual <= 0.4 * total  <=>  5*manual <= 2*total
constraint 5 * manual <= 2 * total;

constraint motion >= min_motion;

constraint drops_motion * motion + drops_manual * manual >= min_drops;
constraint kwh_motion * motion + kwh_manual * manual <= max_kwh;

% Objective
solve minimize total;