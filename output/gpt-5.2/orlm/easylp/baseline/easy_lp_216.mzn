% Resource allocation among departments X, Y, Z
% Minimize total cost with linear constraints and integer allocations.

int: costX = 5;
int: costY = 3;
int: costZ = 2;

int: maxXY = 1000;
int: maxYZ = 800;
int: minXZ = 500;

% Decision variables (whole-number allocations)
var 0..maxXY: X;
var 0..max(maxYZ, minXZ): Y;
var 0..maxYZ: Z;

constraint X + Y <= maxXY;
constraint Y + Z <= maxYZ;
constraint X + Z >= minXZ;

var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "total_cost=", show(total_cost), "\n"
];