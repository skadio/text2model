% Parameters (with values embedded)
int: fatigueX = 4;
int: fatigueY = 2;
int: fatigueZ = 3;

% Bounds on session allocation (embedded due to "specific bounds")
% Since no explicit numeric bounds are provided in the description, we assume non-negative integers.
int: lbX = 0; int: ubX = 100;
int: lbY = 0; int: ubY = 100;
int: lbZ = 0; int: ubZ = 100;

% Variables
var lbX..ubX: X; % strength sessions
var lbY..ubY: Y; % agility sessions
var lbZ..ubZ: Z; % strategy sessions

% Constraints
constraint X + Y >= 6;
constraint abs(Y - Z) <= 1;
constraint X + Z <= 8;

% Objective
var int: total_fatigue = fatigueX*X + fatigueY*Y + fatigueZ*Z;

solve minimize total_fatigue;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "total_fatigue=", show(total_fatigue), "\n"
];