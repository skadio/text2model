% Course enrollment optimization (all data embedded)

int: cap_XY = 30;
int: cap_YZ = 20;
int: min_XZ = 10;

int: costX = 5;
int: costY = 3;
int: costZ = 1;

% Decision variables: integer student enrollments
var 0..cap_XY: X;
var 0..cap_XY: Y;
var 0..cap_XY: Z;

constraint X + Y <= cap_XY;
constraint Y + Z <= cap_YZ;
constraint X + Z >= min_XZ;

var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "min_total_cost=", show(total_cost), "\n"
];