% Parameters
int: min_total_hours = 10;
int: max_diff_XY = 4;
int: max_diff_YZ = 5;

int: maxX = 15;
int: maxY = 20;
int: maxZ = 25;

int: fatigueX = 2;
int: fatigueY = 3;
int: fatigueZ = 1;

% Variables
var 0..maxX: X;
var 0..maxY: Y;
var 0..maxZ: Z;

var 0..(fatigueX*maxX + fatigueY*maxY + fatigueZ*maxZ): total_fatigue;

% Constraints
constraint X + Y + Z >= min_total_hours;

constraint abs(X - Y) <= max_diff_XY;
constraint abs(Y - Z) <= max_diff_YZ;

constraint total_fatigue = fatigueX * X + fatigueY * Y + fatigueZ * Z;

% Objective
solve minimize total_fatigue;