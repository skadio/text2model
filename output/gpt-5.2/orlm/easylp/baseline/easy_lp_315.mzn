% Military resource allocation problem (all data embedded)

var 0..1000: X;
var 0..1000: Y;
var 0..1000: Z;

% Constraints
constraint X + 2*Y + Z >= 100;
constraint 2*X + Y <= 200;
constraint X - Z <= 50;

% Objective: minimize total support points
var int: total_support = 5*X + 6*Y + 4*Z;
solve minimize total_support;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "min_total_support=", show(total_support), "\n"
];