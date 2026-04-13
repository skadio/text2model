% Parameters
int: fatigueX = 2;
int: fatigueY = 3;

int: maxTotalHours = 100;
int: minDiffXY = 10;          % X >= Y + 10
int: minFitnessRHS = 60;      % 2X + Y >= 60

% Variables
var 0..maxTotalHours: X;
var 0..maxTotalHours: Y;
var 0..(fatigueX*maxTotalHours + fatigueY*maxTotalHours): total_fatigue;

% Constraints
constraint X + Y <= maxTotalHours;
constraint X >= Y + minDiffXY;
constraint 2 * X + Y >= minFitnessRHS;

constraint total_fatigue = fatigueX * X + fatigueY * Y;

% Objective
solve minimize total_fatigue;