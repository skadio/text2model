include "globals.mzn";

% Effort per hour
int: cX = 5;
int: cY = 4;
int: cZ = 3;

% Decision variables: whole hours allocated
var 0..1000: X;  % academic lessons
var 0..1000: Y;  % extracurricular activities
var 0..1000: Z;  % counseling sessions

% Constraints
constraint X + Y <= 100;
constraint X + Z >= 50;
constraint abs(Y - Z) <= 20;

% Objective: minimize total effort score
var int: total_effort = cX*X + cY*Y + cZ*Z;

solve minimize total_effort;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total effort score (rounded) = ", show(total_effort), "\n"
];