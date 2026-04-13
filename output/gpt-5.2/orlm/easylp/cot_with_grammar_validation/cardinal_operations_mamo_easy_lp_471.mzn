% Parameters
int: fatigueX = 10;
int: fatigueY = 20;

int: cap = 60;
int: minTotal = 12;
int: maxDiff = 8;

% Variables
var 0..cap: x; % hours for group X (strength)
var 0..cap: y; % hours for group Y (skill)

var 0..(fatigueX*cap + fatigueY*cap): totalFatigue;

% Constraints
constraint 3*x + 2*y <= cap;
constraint x + y >= minTotal;
constraint abs(y - x) <= maxDiff;

constraint totalFatigue = fatigueX*x + fatigueY*y;

% Objective
solve minimize totalFatigue;