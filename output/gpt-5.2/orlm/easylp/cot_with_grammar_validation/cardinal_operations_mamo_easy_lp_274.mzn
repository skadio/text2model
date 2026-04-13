% Parameters
int: fatigueX = 10;
int: fatigueY = 15;
int: fatigueZ = 20;

int: totalHoursMax = 100;

int: maxX = 60;
int: maxY = 50;
int: maxZ = 70;

int: diffXYMin = 20;     % X - Y >= 20
int: diffZXMax = 30;     % Z - X <= 30

% Variables
var 0..maxX: x;
var 0..maxY: y;
var 0..maxZ: z;

var 0..(fatigueX*maxX + fatigueY*maxY + fatigueZ*maxZ): totalFatigue;

% Constraints
constraint x + y + z <= totalHoursMax;

constraint x - y >= diffXYMin;
constraint z - x <= diffZXMax;

constraint totalFatigue = fatigueX*x + fatigueY*y + fatigueZ*z;

% Objective
solve minimize totalFatigue;