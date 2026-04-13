% Allocation of hours for activities:
% X: academic lessons
% Y: extracurricular activities
% Z: counseling sessions
% Minimize total effort score.

int: costX = 5;
int: costY = 4;
int: costZ = 3;

int: maxXY = 100;
int: minXZ = 50;
int: maxDiffYZ = 20;

var 0..1000: X;
var 0..1000: Y;
var 0..1000: Z;

constraint X + Y <= maxXY;
constraint X + Z >= minXZ;
constraint abs(Y - Z) <= maxDiffYZ;

var int: total_effort = costX * X + costY * Y + costZ * Z;

solve minimize total_effort;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "minimum_total_effort_rounded=", show(total_effort), "\n"
];