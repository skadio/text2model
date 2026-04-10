% Parameters
% Fatigue score per hour for each group
int: fatigue_X = 2;
int: fatigue_Y = 3;
int: fatigue_Z = 4;
int: fatigue_W = 5;

% Capacity constraints
int: max_XY = 10;   % X + Y cannot exceed 10
int: max_ZW = 12;   % Z + W cannot exceed 12

% Minimum balance requirements
int: min_XZ = 6;    % X + Z must be at least 6
int: min_YW = 8;    % Y + W must be at least 8

% Per-group training hour bounds
int: min_X = 0; int: max_X = 5;
int: min_Y = 0; int: max_Y = 5;
int: min_Z = 0; int: max_Z = 6;
int: min_W = 0; int: max_W = 6;


% Variables
% Integer training hours allocated to each group (discrete time slots)
var min_X..max_X: hours_X;
var min_Y..max_Y: hours_Y;
var min_Z..max_Z: hours_Z;
var min_W..max_W: hours_W;

% Total fatigue score (linear expression of hours and per-hour fatigue rates)
var int: total_fatigue;


% Constraints
% --- Facility/trainer capacity constraints (upper bounds) ---
constraint hours_X + hours_Y <= max_XY;
constraint hours_Z + hours_W <= max_ZW;

% --- Program balance constraints (lower bounds) ---
constraint hours_X + hours_Z >= min_XZ;
constraint hours_Y + hours_W >= min_YW;

% --- Define total fatigue score from per-hour fatigue rates ---
constraint
  total_fatigue =
    fatigue_X * hours_X +
    fatigue_Y * hours_Y +
    fatigue_Z * hours_Z +
    fatigue_W * hours_W;


% Objective
solve minimize total_fatigue;

output [
  "hours_X=", show(hours_X), "\n",
  "hours_Y=", show(hours_Y), "\n",
  "hours_Z=", show(hours_Z), "\n",
  "hours_W=", show(hours_W), "\n",
  "total_fatigue=", show(total_fatigue), "\n"
];