% Parameters (with values embedded)
int: fatigueX = 10;
int: fatigueY = 15;
int: fatigueZ = 5;

int: minXY = 8;          % X + Y >= 8
int: maxYZ = 20;         % Y + Z <= 20
int: minXminusZ = 3;     % X >= Z + 3

% Specific bounds on training time (assumed non-negative whole hours)
int: maxHours = 100;     % safe upper bound to keep the model bounded

% Variables
var 0..maxHours: X;      % hours for group X
var 0..maxHours: Y;      % hours for group Y
var 0..maxHours: Z;      % hours for group Z

var 0..(fatigueX*maxHours + fatigueY*maxHours + fatigueZ*maxHours): totalFatigue;

% Constraints
constraint X + Y >= minXY;
constraint Y + Z <= maxYZ;
constraint X >= Z + minXminusZ;

constraint totalFatigue = fatigueX*X + fatigueY*Y + fatigueZ*Z;

% Objective
solve minimize totalFatigue;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "Minimum total fatigue score (rounded) = ", show(totalFatigue), "\n"
];