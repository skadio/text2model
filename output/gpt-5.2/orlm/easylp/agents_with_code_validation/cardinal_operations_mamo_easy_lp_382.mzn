% Parameters
% Fatigue score per hour for each group
int: fatigue_X = 2;
int: fatigue_Y = 3;
int: fatigue_Z = 4;
int: fatigue_W = 5;

% Capacity / coupling limits
int: max_XY = 10;     % X + Y <= 10
int: max_ZW = 12;     % Z + W <= 12

% Minimum balance requirements
int: min_XZ = 6;      % X + Z >= 6
int: min_YW = 8;      % Y + W >= 8

% Individual hour bounds (integer time slots)
int: min_X = 0; int: max_X = 5;
int: min_Y = 0; int: max_Y = 5;
int: min_Z = 0; int: max_Z = 6;
int: min_W = 0; int: max_W = 6;


% Variables
var min_X..max_X: hours_X;  % training hours for group X
var min_Y..max_Y: hours_Y;  % training hours for group Y
var min_Z..max_Z: hours_Z;  % training hours for group Z
var min_W..max_W: hours_W;  % training hours for group W

% Total fatigue to be minimized (upper bound from individual maxima)
var 0..(max_X*fatigue_X + max_Y*fatigue_Y + max_Z*fatigue_Z + max_W*fatigue_W): total_fatigue;


% Constraints
% --- Facility / trainer capacity coupling constraints ---
constraint hours_X + hours_Y <= max_XY;
constraint hours_Z + hours_W <= max_ZW;

% --- Balanced program minimum requirements ---
constraint hours_X + hours_Z >= min_XZ;
constraint hours_Y + hours_W >= min_YW;

% --- Total fatigue accounting ---
constraint total_fatigue =
    fatigue_X * hours_X +
    fatigue_Y * hours_Y +
    fatigue_Z * hours_Z +
    fatigue_W * hours_W;


% Objective
solve minimize total_fatigue;