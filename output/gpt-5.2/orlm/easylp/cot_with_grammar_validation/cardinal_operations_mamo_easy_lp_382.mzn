% Parameters
int: fatigue_X = 2;
int: fatigue_Y = 3;
int: fatigue_Z = 4;
int: fatigue_W = 5;

int: max_XY = 10;
int: max_ZW = 12;
int: min_XZ = 6;
int: min_YW = 8;

int: min_X = 0; int: max_X = 5;
int: min_Y = 0; int: max_Y = 5;
int: min_Z = 0; int: max_Z = 6;
int: min_W = 0; int: max_W = 6;

% Variables
var min_X..max_X: X;
var min_Y..max_Y: Y;
var min_Z..max_Z: Z;
var min_W..max_W: W;

var 0..(fatigue_X*max_X + fatigue_Y*max_Y + fatigue_Z*max_Z + fatigue_W*max_W): total_fatigue;

% Constraints
constraint X + Y <= max_XY;
constraint Z + W <= max_ZW;
constraint X + Z >= min_XZ;
constraint Y + W >= min_YW;

constraint total_fatigue = fatigue_X*X + fatigue_Y*Y + fatigue_Z*Z + fatigue_W*W;

% Objective
solve minimize total_fatigue;