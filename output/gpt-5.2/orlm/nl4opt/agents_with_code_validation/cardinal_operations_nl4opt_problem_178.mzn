% Parameters
int: drops_motion = 50;           % drops per minute delivered by one motion-activated machine
int: drops_manual = 75;           % drops per minute delivered by one manual machine
int: kwh_motion = 30;             % kWh consumed per minute by one motion-activated machine
int: kwh_manual = 20;             % kWh consumed per minute by one manual machine

float: max_manual_fraction = 0.4; % at most 40% of machines can be manual (captured via scaled integer constraint)
int: min_motion = 3;              % at least 3 motion-activated machines

int: min_total_drops = 1000;      % must deliver at least 1000 drops per minute
int: max_total_kwh = 500;         % can use at most 500 kWh per minute


% Variables
% Upper bounds derived from the energy cap (max_total_kwh)
var 0..ceil(int2float(max_total_kwh) / int2float(kwh_motion)): motion_machines;
var 0..ceil(int2float(max_total_kwh) / int2float(kwh_manual)): manual_machines;

% Total machine count; upper bound based on the cheapest (in kWh) machine
var 0..ceil(int2float(max_total_kwh) / int2float(min(kwh_motion, kwh_manual))): total_machines;


% Constraints
% Total machines definition
constraint total_machines = motion_machines + manual_machines;

% Minimum number of motion-activated machines
constraint motion_machines >= min_motion;

% Required minimum total drops per minute
constraint drops_motion * motion_machines + drops_manual * manual_machines >= min_total_drops;

% Maximum allowed total kWh consumption per minute
constraint kwh_motion * motion_machines + kwh_manual * manual_machines <= max_total_kwh;

% Manual machines fraction cap: manual <= 0.4 * total (avoid floats by scaling)
constraint 10 * manual_machines <= 4 * total_machines;


% Objective
solve minimize total_machines;