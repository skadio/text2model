% Parameters
int: max_total_hours = 1000;
int: min_X = 200;
int: min_Y = 150;
int: min_Z = 250;

int: fatigue_X = 2;
int: fatigue_Y = 3;
int: fatigue_Z = 4;

% Variables
var min_X..max_total_hours: X;
var min_Y..max_total_hours: Y;
var min_Z..max_total_hours: Z;

var 0..(fatigue_X*max_total_hours + fatigue_Y*max_total_hours + fatigue_Z*max_total_hours): total_fatigue;

% Constraints
constraint X + Y + Z <= max_total_hours;

constraint total_fatigue = fatigue_X * X + fatigue_Y * Y + fatigue_Z * Z;

% Objective
solve minimize total_fatigue;