int: supportX = 5000;
int: supportY = 3000;

int: minUnits = 50;
int: maxStrength = 200;

% Decision variables: number of units of type X and Y (integers, nonnegative)
var 0..maxStrength: X;
var 0..maxStrength: Y;

% Constraints
constraint X + Y >= minUnits;
constraint 5 * X + 3 * Y <= maxStrength;

% Objective: minimize total support points
var int: totalSupport = supportX * X + supportY * Y;

solve minimize totalSupport;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "TotalSupport = ", show(totalSupport), "\n"
];