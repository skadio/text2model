% Marketing budget allocation (integer) with minimum total cost

% Data (embedded as requested)
int: maxXY = 100;
int: maxZW = 200;
int: minXZ = 50;
int: minYW = 70;

int: cX = 10;
int: cY = 15;
int: cZ = 25;
int: cW = 30;

% Decision variables: integer dollar allocations
var 0..maxXY: X;
var 0..maxXY: Y;
var 0..maxZW: Z;
var 0..maxZW: W;

% Constraints
constraint X + Y <= maxXY;
constraint Z + W <= maxZW;
constraint X + Z >= minXZ;
constraint Y + W >= minYW;

% Objective: minimize total cost
var int: total_cost = cX*X + cY*Y + cZ*Z + cW*W;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "W = ", show(W), "\n",
  "Minimum total cost = $", show(total_cost), "\n"
];