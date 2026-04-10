% Parameters
% Upper bounds on hours for each exercise type
int: maxX = 15;
int: maxY = 20;
int: maxZ = 25;

% Minimum total hours required
int: minTotalHours = 10;

% Maximum allowed differences between exercise hours
int: maxDiffXY = 4;
int: maxDiffYZ = 5;

% Fatigue per hour for each exercise type
int: fatigueX = 2;
int: fatigueY = 3;
int: fatigueZ = 1;


% Variables
% Whole number hours allocated to each exercise type (bounded by given limits)
var 0..maxX: hoursX;
var 0..maxY: hoursY;
var 0..maxZ: hoursZ;

% Total fatigue score to be minimized (bounded using maxima)
var 0..(fatigueX*maxX + fatigueY*maxY + fatigueZ*maxZ): totalFatigue;


% Constraints
% Total hours requirement: ensure enough training time is allocated
constraint hoursX + hoursY + hoursZ >= minTotalHours;

% Difference constraints: keep allocations between exercise types within allowed bounds
constraint abs(hoursX - hoursY) <= maxDiffXY;
constraint abs(hoursY - hoursZ) <= maxDiffYZ;

% Total fatigue definition: link totalFatigue to the chosen exercise hours
constraint totalFatigue = fatigueX * hoursX + fatigueY * hoursY + fatigueZ * hoursZ;


% Objective
solve minimize totalFatigue;