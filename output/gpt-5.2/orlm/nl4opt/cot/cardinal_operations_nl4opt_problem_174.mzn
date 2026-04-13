% Parameters (with values embedded)
int: time_open = 15000;
int: time_e = 3;          % minutes per electronic reading
int: time_r = 2;          % minutes per regular reading
int: min_regular = 50;    % at least this many regular readings

% Variables
var 0..(time_open div time_e): e;     % number of electronic thermometer patients
var 0..(time_open div time_r): r;     % number of regular thermometer patients

% Constraints
constraint time_e * e + time_r * r <= time_open;
constraint e >= 2 * r;
constraint r >= min_regular;

% Objective
solve maximize e + r;