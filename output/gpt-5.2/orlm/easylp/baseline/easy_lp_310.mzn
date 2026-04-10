% Military resource allocation - embedded data

var 0..100: X;
var 0..100: Y;
var 0..100: Z;

% Constraints
constraint X + Y + Z <= 100;
constraint 5 * X + 3 * Y >= 50;
constraint abs(Z - Y) <= 30;

% Support points per unit
int: sx = 500;
int: sy = 600;
int: sz = 700;

var int: total_support = sx * X + sy * Y + sz * Z;

solve minimize total_support;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "min_total_support=", show(total_support), "\n"
];