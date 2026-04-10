% Training schedule optimization (fatigue minimization)
% All data embedded as requested.

include "globals.mzn";

% Fatigue per hour
int: fx = 10;
int: fy = 15;
int: fz = 5;

% Decision variables: whole numbers of hours
% (Bounds are not explicitly given in the description, so we use natural nonnegative bounds.
% A safe upper bound is chosen to keep the model finite and consistent with constraints.)
var 0..100: X;   % strength conditioning hours
var 0..100: Y;   % skill development hours
var 0..100: Z;   % strategy & tactics hours

% Constraints
constraint X + Y >= 8;
constraint Y + Z <= 20;
constraint X >= Z + 3;

% Objective: minimize total fatigue score
var 0..100000: total_fatigue = fx*X + fy*Y + fz*Z;
solve minimize total_fatigue;

output [
  "X=", show(X), " hours\n",
  "Y=", show(Y), " hours\n",
  "Z=", show(Z), " hours\n",
  "Total fatigue=", show(total_fatigue), "\n"
];