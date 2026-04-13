include "globals.mzn";

% Data (embedded as required)
int: min_total_hours = 10;

int: maxX = 15;
int: maxY = 20;
int: maxZ = 25;

int: diffXY = 4;
int: diffYZ = 5;

int: fatigueX = 2;
int: fatigueY = 3;
int: fatigueZ = 1;

% Decision variables: whole number hours
var 0..maxX: X;
var 0..maxY: Y;
var 0..maxZ: Z;

% Constraints
constraint X + Y + Z >= min_total_hours;

constraint abs(X - Y) <= diffXY;
constraint abs(Y - Z) <= diffYZ;

% Objective: minimize total fatigue score
var 0..(fatigueX*maxX + fatigueY*maxY + fatigueZ*maxZ): total_fatigue;
constraint total_fatigue = fatigueX*X + fatigueY*Y + fatigueZ*Z;

solve minimize total_fatigue;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total fatigue (rounded) = ", show(total_fatigue), "\n"
];