% Parameters (with values embedded)
int: drops_motion = 50;
int: drops_manual = 75;
int: kwh_motion = 30;
int: kwh_manual = 20;

int: min_total_drops = 1000;
int: max_total_kwh = 500;

int: min_motion = 3;

% Variables
var 0..1000: motion;  % number of motion activated machines
var 0..1000: manual;  % number of manual machines
var 0..2000: total_machines;

% Constraints
constraint motion >= min_motion;

constraint total_machines = motion + manual;

% At most 40% of machines can be manual: manual <= 0.4 * total_machines
% Use integer form to avoid floats: 5*manual <= 2*total_machines
constraint 5 * manual <= 2 * total_machines;

% Delivery requirement
constraint drops_motion * motion + drops_manual * manual >= min_total_drops;

% Energy limit
constraint kwh_motion * motion + kwh_manual * manual <= max_total_kwh;

% Objective
solve minimize total_machines;