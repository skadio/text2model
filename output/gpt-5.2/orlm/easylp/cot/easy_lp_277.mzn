% Parameters (with values embedded)
int: fatigue_X = 6;
int: fatigue_Y = 3;
int: fatigue_Z = 5;

int: min_XY = 8;
int: max_XZ = 10;
int: min_Y_minus_Z = 2;

% Variables
var 0..100: X; % strength hours (integer, non-negative)
var 0..100: Y; % endurance hours (integer, non-negative)
var 0..100: Z; % agility hours (integer, non-negative)

var 0..10000: total_fatigue;

% Constraints
constraint X + Y >= min_XY;
constraint X + Z <= max_XZ;
constraint Y - Z >= min_Y_minus_Z;

constraint total_fatigue = fatigue_X * X + fatigue_Y * Y + fatigue_Z * Z;

% Objective
solve minimize total_fatigue;