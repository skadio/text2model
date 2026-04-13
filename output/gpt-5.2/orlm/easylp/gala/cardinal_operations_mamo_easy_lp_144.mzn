% Resource allocation between unit types X and Y
% Minimize total support points subject to operational and logistics constraints.

int: supportX = 5000;
int: supportY = 3000;

int: minUnits = 50;
int: maxStrength = 200;          % 5*X + 3*Y <= 200
int: strengthX = 5;
int: strengthY = 3;

% Decision variables (integers, nonnegative)
var 0..maxStrength div strengthX: x;  % safe upper bound
var 0..maxStrength div strengthY: y;  % safe upper bound

% Objective: minimize total support points
var int: totalSupport = supportX * x + supportY * y;

% Constraints
constraint x + y >= minUnits;
constraint strengthX * x + strengthY * y <= maxStrength;

solve minimize totalSupport;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "totalSupport = ", show(totalSupport), "\n",
  "strength = ", show(strengthX*x + strengthY*y), "\n",
  "totalUnits = ", show(x + y), "\n"
];