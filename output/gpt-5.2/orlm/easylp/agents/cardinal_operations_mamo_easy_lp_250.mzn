% Parameters
int: timeX = 1;          % hours per task X
int: timeY = 2;          % hours per task Y
int: timeZ = 3;          % hours per task Z

int: maxTime_2X_plus_Y = 6;  % upper bound on time for (2*X + Y)
int: maxTime_X_plus_Z  = 5;  % upper bound on time for (X + Z)
int: minTime_Y_plus_Z  = 7;  % lower bound on time for (Y + Z)

% Variables
var 0..100: nX;          % number of tasks of type X (nonnegative integer)
var 0..100: nY;          % number of tasks of type Y (nonnegative integer)
var 0..100: nZ;          % number of tasks of type Z (nonnegative integer)

var 0..1000: totalHours; % total hours spent on all tasks

% Constraints
% --- Time-limit constraints from the schedule rules ---

% (1) Combined time for twice as many X plus Y cannot exceed maxTime_2X_plus_Y
constraint (2 * nX) * timeX + nY * timeY <= maxTime_2X_plus_Y;

% (2) Combined time for X plus Z cannot exceed maxTime_X_plus_Z
constraint nX * timeX + nZ * timeZ <= maxTime_X_plus_Z;

% (3) Total time spent on Y and Z must be at least minTime_Y_plus_Z
constraint nY * timeY + nZ * timeZ >= minTime_Y_plus_Z;

% --- Definition of total hours ---
constraint totalHours = nX * timeX + nY * timeY + nZ * timeZ;

% Objective
solve minimize totalHours;