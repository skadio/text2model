% Parameters
int: fatigue_X = 4;
int: fatigue_Y = 2;
int: fatigue_Z = 3;

int: min_X = 0;
int: max_X = 8;

int: min_Y = 0;
int: max_Y = 8;

int: min_Z = 0;
int: max_Z = 8;

% Variables
var min_X..max_X: X;
var min_Y..max_Y: Y;
var min_Z..max_Z: Z;

var 0..(fatigue_X*max_X + fatigue_Y*max_Y + fatigue_Z*max_Z): total_fatigue;

% Constraints
constraint X + Y >= 6;
constraint abs(Y - Z) <= 1;
constraint X + Z <= 8;

constraint total_fatigue = fatigue_X*X + fatigue_Y*Y + fatigue_Z*Z;

% Objective
solve minimize total_fatigue;