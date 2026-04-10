% Parameters
int: fatigueX = 2;
int: fatigueY = 3;

int: maxTotalHours = 100;
int: minDiffXY = 10;          % X >= Y + 10
int: minFitness = 60;         % 2X + Y >= 60

% Variables
var 0..maxTotalHours: X;      % hours for group X
var 0..maxTotalHours: Y;      % hours for group Y
var 0..(fatigueX*maxTotalHours + fatigueY*maxTotalHours): totalFatigue;

% Constraints
constraint X + Y <= maxTotalHours;
constraint X >= Y + minDiffXY;
constraint 2*X + Y >= minFitness;

constraint totalFatigue = fatigueX*X + fatigueY*Y;

% Objective
solve minimize totalFatigue;