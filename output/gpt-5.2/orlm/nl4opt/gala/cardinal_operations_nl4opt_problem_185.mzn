% Wraps and platters production planning (minimize total time)

% Data (embedded from problem statement)
int: meat_per_wrap = 5;
int: rice_per_wrap = 3;
int: meat_per_platter = 7;
int: rice_per_platter = 5;

int: time_wrap = 10;     % minutes
int: time_platter = 8;   % minutes

int: meat_min = 3000;
int: rice_min = 2500;

% Decision variables
% Safe upper bounds from minimum resource requirements
int: max_wraps = max(meat_min div meat_per_wrap, rice_min div rice_per_wrap) + 1000;
int: max_platters = max(meat_min div meat_per_platter, rice_min div rice_per_platter) + 1000;

var 0..max_wraps: wraps;
var 0..max_platters: platters;

% Constraints
constraint meat_per_wrap * wraps + meat_per_platter * platters >= meat_min;
constraint rice_per_wrap * wraps + rice_per_platter * platters >= rice_min;
constraint wraps >= 3 * platters;

% Objective: minimize total production time
var int: total_time = time_wrap * wraps + time_platter * platters;

solve minimize total_time;

output [
  "wraps = ", show(wraps), "\n",
  "platters = ", show(platters), "\n",
  "total_time = ", show(total_time), " minutes\n",
  "meat_used = ", show(meat_per_wrap * wraps + meat_per_platter * platters), "\n",
  "rice_used = ", show(rice_per_wrap * wraps + rice_per_platter * platters), "\n"
];