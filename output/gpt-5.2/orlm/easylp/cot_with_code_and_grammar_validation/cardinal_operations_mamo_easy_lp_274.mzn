% Parameters
int: fatigue_X = 10;
int: fatigue_Y = 15;
int: fatigue_Z = 20;

int: max_total_hours = 100;

int: min_diff_XY = 20;        % X - Y >= 20
int: max_diff_ZX = 30;        % Z - X <= 30

int: max_X = 60;
int: max_Y = 50;
int: max_Z = 70;

% Variables
var 0..max_X: X;
var 0..max_Y: Y;
var 0..max_Z: Z;

var 0..(fatigue_X*max_X + fatigue_Y*max_Y + fatigue_Z*max_Z): total_fatigue;

% Constraints
constraint X + Y + Z <= max_total_hours;

constraint X - Y >= min_diff_XY;
constraint Z - X <= max_diff_ZX;

constraint total_fatigue = fatigue_X * X + fatigue_Y * Y + fatigue_Z * Z;

% Objective
solve minimize total_fatigue;