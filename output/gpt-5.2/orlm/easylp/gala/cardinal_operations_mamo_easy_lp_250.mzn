include "globals.mzn";

% Task durations (hours per task)
int: dx = 1;
int: dy = 2;
int: dz = 3;

% Decision variables: number of tasks (whole numbers)
var 0..100: x;   % number of X tasks
var 0..100: y;   % number of Y tasks
var 0..100: z;   % number of Z tasks

% Constraints (expressed in hours)
constraint 2*x*dx + y*dy <= 6;   % twice as many X plus Y
constraint x*dx + z*dz <= 5;     % X plus Z
constraint y*dy + z*dz >= 7;     % Y and Z at least 7 hours

% Objective: minimize total hours spent on all tasks
var 0..1000: total_hours = x*dx + y*dy + z*dz;

solve minimize total_hours;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "total_hours = ", show(total_hours), "\n"
];