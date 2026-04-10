% Parameters
% Task durations (hours per task)
int: durX = 1;
int: durY = 2;
int: durZ = 3;

% Constraint right-hand sides (hours)
int: maxTime_2X_plus_Y = 6;     % limit for 2*(time of X) + (time of Y)
int: maxTime_X_plus_Z  = 5;     % limit for (time of X) + (time of Z)
int: minTime_Y_plus_Z  = 7;     % minimum for (time of Y) + (time of Z)

% Variables
% Numbers of tasks (non-negative integers). Tighten domains using the tightest RHS-based bounds.
var 0..maxTime_X_plus_Z: x;            % x <= 5 from x + 3z <= 5
var 0..(maxTime_2X_plus_Y div durY): y; % 2*y <= 6 -> y <= 3
var 0..(maxTime_X_plus_Z div durZ): z;  % 3*z <= 5 -> z <= 1

% Total hours spent (objective)
var 0..(durX*maxTime_X_plus_Z + durY*(maxTime_2X_plus_Y div durY) + durZ*(maxTime_X_plus_Z div durZ)): totalHours;

% Constraints
% Define total hours spent on tasks
constraint totalHours = durX * x + durY * y + durZ * z;

% Limit on combined time for twice as many X tasks plus Y tasks:
% 2*(durX*x) + (durY*y) <= maxTime_2X_plus_Y
constraint 2 * durX * x + durY * y <= maxTime_2X_plus_Y;

% Limit on combined time for X and Z tasks:
% (durX*x) + (durZ*z) <= maxTime_X_plus_Z
constraint durX * x + durZ * z <= maxTime_X_plus_Z;

% Minimum required combined time for Y and Z tasks:
% (durY*y) + (durZ*z) >= minTime_Y_plus_Z
constraint durY * y + durZ * z >= minTime_Y_plus_Z;

% Objective
solve minimize totalHours;