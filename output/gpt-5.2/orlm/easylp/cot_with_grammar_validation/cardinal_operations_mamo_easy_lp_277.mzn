% Parameters
int: fatigue_X = 6;
int: fatigue_Y = 3;
int: fatigue_Z = 5;

int: min_XY = 8;        % X + Y >= 8
int: max_XZ = 10;       % X + Z <= 10
int: min_YminusZ = 2;   % Y - Z >= 2

% Variables
var 0..100: X;  % strength hours
var 0..100: Y;  % endurance hours
var 0..100: Z;  % agility hours

var 0..(fatigue_X*100 + fatigue_Y*100 + fatigue_Z*100): total_fatigue;

% Constraints
constraint X + Y >= min_XY;
constraint X + Z <= max_XZ;
constraint Y - Z >= min_YminusZ;

constraint total_fatigue = fatigue_X * X + fatigue_Y * Y + fatigue_Z * Z;

% Objective
solve minimize total_fatigue;