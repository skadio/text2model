% Resource allocation optimization for projects X, Y, Z

var 0..1000: X;
var 0..1000: Y;
var 0..1000: Z;

% Constraints
constraint X + Y + Z <= 1000;
constraint 2*X + Y >= 500;
constraint X + 3*Z <= 800;

% Cost coefficients ($ per unit)
int: cX = 10;
int: cY = 15;
int: cZ = 20;

var int: total_cost = cX*X + cY*Y + cZ*Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];