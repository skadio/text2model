include "globals.mzn";

% Data (embedded as requested)
int: maxTotal = 100;

int: maxX = 60;
int: maxY = 50;
int: maxZ = 70;

int: fatigueX = 10;
int: fatigueY = 15;
int: fatigueZ = 20;

int: minDiffXY = 20;  % X - Y >= 20
int: maxDiffZX = 30;  % Z - X <= 30

% Decision variables: whole hours
var 0..maxX: x;
var 0..maxY: y;
var 0..maxZ: z;

% Total fatigue score
var int: totalFatigue = fatigueX * x + fatigueY * y + fatigueZ * z;

% Constraints
constraint x + y + z <= maxTotal;
constraint x - y >= minDiffXY;
constraint z - x <= maxDiffZX;

solve minimize totalFatigue;

output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "totalFatigue=", show(totalFatigue), "\n"
];