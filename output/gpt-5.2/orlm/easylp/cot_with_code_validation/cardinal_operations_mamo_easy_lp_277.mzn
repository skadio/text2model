% Parameters
int: fatigue_x = 6;
int: fatigue_y = 3;
int: fatigue_z = 5;

int: min_x_plus_y = 8;
int: max_x_plus_z = 10;
int: min_y_minus_z = 2;

int: UB = 100;

% Variables
var 0..UB: X; % strength hours
var 0..UB: Y; % endurance hours
var 0..UB: Z; % agility hours

var 0..(fatigue_x*UB + fatigue_y*UB + fatigue_z*UB): total_fatigue;

% Constraints
constraint X + Y >= min_x_plus_y;
constraint X + Z <= max_x_plus_z;
constraint Y - Z >= min_y_minus_z;

constraint total_fatigue = fatigue_x * X + fatigue_y * Y + fatigue_z * Z;

% Objective
solve minimize total_fatigue;