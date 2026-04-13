% Parameters (with values embedded)
int: fatigueX = 10;
int: fatigueY = 15;
int: fatigueZ = 20;

int: totalHoursMax = 100;

int: maxX = 60;
int: maxY = 50;
int: maxZ = 70;

int: minDiffXY = 20;   % X - Y >= 20
int: maxDiffZX = 30;   % Z - X <= 30

% Variables
var 0..maxX: X;
var 0..maxY: Y;
var 0..maxZ: Z;

var 0..(fatigueX*maxX + fatigueY*maxY + fatigueZ*maxZ): totalFatigue;

% Constraints
constraint X + Y + Z <= totalHoursMax;

constraint X - Y >= minDiffXY;
constraint Z - X <= maxDiffZX;

constraint totalFatigue = fatigueX*X + fatigueY*Y + fatigueZ*Z;

% Objective
solve minimize totalFatigue;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "Minimum total fatigue score (rounded to nearest whole number): ", show(totalFatigue), "\n"
];