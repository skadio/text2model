include "globals.mzn";

% Data (embedded from problem statement)
int: intensityX = 8;     % units per hour for exercise X
int: intensityY = 12;    % units per hour for exercise Y
int: maxHours = 20;

int: effX = 5;           % effectiveness coefficient for X
int: effY = 3;           % effectiveness coefficient for Y
int: minEffect = 15;

% Decision variables (whole hours)
var 0..maxHours: x;      % hours on exercise X
var 0..maxHours: y;      % hours on exercise Y

% Constraints
constraint x + y <= maxHours;
constraint effX * x + effY * y >= minEffect;

% Objective: minimize total intensity score
var 0..(intensityX*maxHours + intensityY*maxHours): totalIntensity =
  intensityX * x + intensityY * y;

solve minimize totalIntensity;

output [
  "x_hours = ", show(x), "\n",
  "y_hours = ", show(y), "\n",
  "min_total_intensity = ", show(totalIntensity), "\n"
];