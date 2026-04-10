% Energy investment allocation problem (all data embedded)

int: max_XY = 100;
int: min_XZ = 150;
int: max_YZ = 200;

int: cX = 3;
int: cY = 4;
int: cZ = 5;

% Decision variables (integer investments)
var 0..1000: X;
var 0..1000: Y;
var 0..1000: Z;

constraint X + Y <= max_XY;
constraint X + Z >= min_XZ;
constraint Y + Z <= max_YZ;

var int: total_cost = cX*X + cY*Y + cZ*Z;

solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "min_total_cost=", show(total_cost), "\n"
];