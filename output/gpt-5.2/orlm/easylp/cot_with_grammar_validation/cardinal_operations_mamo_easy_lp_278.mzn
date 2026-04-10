% Parameters
int: fatigueX = 4;
int: fatigueY = 2;
int: fatigueZ = 3;

% Variables
var int: X;
var int: Y;
var int: Z;

var int: total_fatigue;

% Constraints
constraint X + Y >= 6;
constraint Y - Z <= 1;
constraint Z - Y <= 1;
constraint X + Z <= 8;

constraint total_fatigue = fatigueX * X + fatigueY * Y + fatigueZ * Z;

% Objective
solve minimize total_fatigue;