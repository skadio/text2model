% Weekly work schedule optimization for teams X, Y, Z
% All data embedded as required.

include "globals.mzn";

% Parameters (from problem statement)
int: maxTotalHours = 40;

int: maxX = 15;
int: maxY = 20;
int: maxZ = 30;

int: fatigueX = 2;
int: fatigueY = 3;
int: fatigueZ = 1;

int: diffXY = 5;   % X at least 5 more than Y
int: diffYZ = 10;  % Y at least 10 more than Z

% Decision variables: whole hours
var 0..maxX: X;
var 0..maxY: Y;
var 0..maxZ: Z;

% Constraints
constraint X + Y + Z <= maxTotalHours;
constraint X >= Y + diffXY;
constraint Y >= Z + diffYZ;

% Objective: minimize total fatigue score
var int: totalFatigue = fatigueX * X + fatigueY * Y + fatigueZ * Z;

solve minimize totalFatigue;

output [
  "X_hours = ", show(X), "\n",
  "Y_hours = ", show(Y), "\n",
  "Z_hours = ", show(Z), "\n",
  "Minimum total fatigue (rounded) = ", show(totalFatigue), "\n"
];