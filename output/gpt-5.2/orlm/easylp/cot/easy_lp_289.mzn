% Parameters (with values embedded)
int: effortX = 5;
int: effortY = 4;
int: effortZ = 3;

int: maxXY = 100;
int: minXZ = 50;
int: maxDiffYZ = 20;

% Variables
var 0..1000: X;  % academic lessons hours
var 0..1000: Y;  % extracurricular activities hours
var 0..1000: Z;  % counseling sessions hours

var 0..1000000: total_effort;

% Constraints
constraint X + Y <= maxXY;
constraint X + Z >= minXZ;
constraint abs(Y - Z) <= maxDiffYZ;

constraint total_effort = effortX * X + effortY * Y + effortZ * Z;

% Objective
solve minimize total_effort;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "minimum_total_effort=", show(total_effort), "\n"
];