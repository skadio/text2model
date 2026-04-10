% Parameters
int: max_hours = 1000;
int: min_x = 200;
int: min_y = 150;
int: min_z = 250;

int: fatigue_x = 2;
int: fatigue_y = 3;
int: fatigue_z = 4;

% Variables
var min_x..max_hours: X;
var min_y..max_hours: Y;
var min_z..max_hours: Z;

var 0..(fatigue_x*max_hours + fatigue_y*max_hours + fatigue_z*max_hours): total_fatigue;

% Constraints
constraint X + Y + Z <= max_hours;

constraint total_fatigue = fatigue_x * X + fatigue_y * Y + fatigue_z * Z;

% Objective
solve minimize total_fatigue;