% Parameters
int: time_electronic = 3;           % minutes per patient using electronic thermometer
int: time_regular    = 2;           % minutes per patient using regular thermometer
int: total_time      = 15000;       % total office open time (minutes)
int: min_regular     = 50;          % minimum number of regular-thermometer patients
int: electronic_ratio = 2;          % electronic patients >= electronic_ratio * regular patients

% Variables
var 0..(total_time div time_electronic): n_electronic;  % # patients checked with electronic thermometer
var 0..(total_time div time_regular):    n_regular;     % # patients checked with regular thermometer
var 0..(total_time div min(time_electronic, time_regular)): n_total; % total # patients

% Constraints
% Time capacity: total time spent on all thermometer readings cannot exceed office open time
constraint
  time_electronic * n_electronic + time_regular * n_regular <= total_time;

% Accuracy policy: at least twice as many electronic readings as regular readings
constraint
  n_electronic >= electronic_ratio * n_regular;

% Cooldown policy: ensure a minimum number of regular thermometer readings
constraint
  n_regular >= min_regular;

% Definition of total patients
constraint
  n_total = n_electronic + n_regular;

% Objective
solve maximize n_total;