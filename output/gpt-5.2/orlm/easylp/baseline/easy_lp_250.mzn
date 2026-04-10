include "globals.mzn";

% Decision variables: number of tasks (nonnegative integers)
var 0..20: x; % task X count
var 0..20: y; % task Y count
var 0..20: z; % task Z count

% Time per task (hours)
int: tx = 1;
int: ty = 2;
int: tz = 3;

% Constraints (in hours)
% Twice as many X plus Y cannot exceed 6 hours:
constraint 2 * x * tx + y * ty <= 6;

% X and Z must not exceed 5 hours:
constraint x * tx + z * tz <= 5;

% Y and Z must be at least 7 hours:
constraint y * ty + z * tz >= 7;

% Objective: minimize total hours
var int: total_hours = x * tx + y * ty + z * tz;
solve minimize total_hours;

output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "total_hours=", show(total_hours), "\n"
];