% Parameters
int: fatigue_X = 10;
int: fatigue_Y = 15;
int: fatigue_Z = 5;

int: min_XY = 8;
int: max_YZ = 20;
int: min_diff_XZ = 3;

% Bounds on decision variables (hours)
int: X_lb = 0;
int: X_ub = 100;
int: Y_lb = 0;
int: Y_ub = 100;
int: Z_lb = 0;
int: Z_ub = 100;

% Variables
var X_lb..X_ub: X; % hours for strength conditioning
var Y_lb..Y_ub: Y; % hours for skill development
var Z_lb..Z_ub: Z; % hours for strategy and tactics

var 0..(fatigue_X*X_ub + fatigue_Y*Y_ub + fatigue_Z*Z_ub): total_fatigue;

% Constraints
constraint X + Y >= min_XY;
constraint Y + Z <= max_YZ;
constraint X >= Z + min_diff_XZ;

constraint total_fatigue = fatigue_X*X + fatigue_Y*Y + fatigue_Z*Z;

% Objective
solve minimize total_fatigue;