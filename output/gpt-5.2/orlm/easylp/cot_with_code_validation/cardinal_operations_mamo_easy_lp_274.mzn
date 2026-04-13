% Parameters
int: fatigue_X = 10;
int: fatigue_Y = 15;
int: fatigue_Z = 20;

int: total_hours_max = 100;

int: X_max = 60;
int: Y_max = 50;
int: Z_max = 70;

int: diff_XY_min = 20;     % X - Y >= 20
int: diff_ZX_max = 30;     % |Z - X| <= 30

% Variables
var 0..X_max: X;
var 0..Y_max: Y;
var 0..Z_max: Z;

var 0..(fatigue_X*X_max + fatigue_Y*Y_max + fatigue_Z*Z_max): total_fatigue;

% Constraints
constraint X + Y + Z <= total_hours_max;

constraint X - Y >= diff_XY_min;

constraint abs(Z - X) <= diff_ZX_max;

constraint total_fatigue = fatigue_X * X + fatigue_Y * Y + fatigue_Z * Z;

% Objective
solve minimize total_fatigue;