% Parameters
int: fatigue_X = 10;
int: fatigue_Y = 15;
int: fatigue_Z = 5;

int: min_XY = 8;
int: max_YZ = 20;
int: min_X_minus_Z = 3;

% Given "specific bounds on training time" are mentioned but not provided,
% we impose non-negativity bounds for feasibility and boundedness follows from constraints.
int: max_hour = 1000;

% Variables
var 0..max_hour: X; % hours for group X
var 0..max_hour: Y; % hours for group Y
var 0..max_hour: Z; % hours for group Z

var 0..(fatigue_X*max_hour + fatigue_Y*max_hour + fatigue_Z*max_hour): total_fatigue;

% Constraints
constraint X + Y >= min_XY;
constraint Y + Z <= max_YZ;
constraint X >= Z + min_X_minus_Z;

constraint total_fatigue = fatigue_X * X + fatigue_Y * Y + fatigue_Z * Z;

% Objective
solve minimize total_fatigue;