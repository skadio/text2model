include "globals.mzn";

% Data (embedded as requested)
int: maxTotalHours = 1000;

int: minX = 200;   % Strength conditioning
int: minY = 150;   % Skill development
int: minZ = 250;   % Strategy & tactics

int: fatigueX = 2;
int: fatigueY = 3;
int: fatigueZ = 4;

% Decision variables: whole numbers of hours
var minX..maxTotalHours: X;
var minY..maxTotalHours: Y;
var minZ..maxTotalHours: Z;

% Constraints
constraint X + Y + Z <= maxTotalHours;

% Objective: minimize total fatigue score
var 0..fatigueX*maxTotalHours + fatigueY*maxTotalHours + fatigueZ*maxTotalHours: totalFatigue;
constraint totalFatigue = fatigueX*X + fatigueY*Y + fatigueZ*Z;

solve minimize totalFatigue;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "totalFatigue=", show(totalFatigue), "\n"
];