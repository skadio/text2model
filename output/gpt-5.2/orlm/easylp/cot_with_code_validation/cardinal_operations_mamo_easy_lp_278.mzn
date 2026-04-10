% Parameters
int: fatX = 4;
int: fatY = 2;
int: fatZ = 3;

% Variables
var int: X;
var int: Y;
var int: Z;

var int: total_fatigue;

% Constraints
constraint X + Y >= 6;
constraint abs(Y - Z) <= 1;
constraint X + Z <= 8;

constraint total_fatigue = fatX * X + fatY * Y + fatZ * Z;

% Objective
solve minimize total_fatigue;