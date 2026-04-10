% Machinery rental cost minimization (all data embedded)

int: costX = 4000;
int: costY = 3000;
int: costZ = 6000;
int: costW = 5000;

int: maxX = 30;
int: maxY = 25;
int: maxZ = 20;
int: maxW = 15;

int: maxXY = 50;
int: maxZW = 40;

int: minXZ = 30;
int: minYW = 20;

var 0..maxX: X;
var 0..maxY: Y;
var 0..maxZ: Z;
var 0..maxW: W;

constraint X + Y <= maxXY;
constraint Z + W <= maxZW;

constraint X + Z >= minXZ;
constraint Y + W >= minYW;

var int: total_cost = costX*X + costY*Y + costZ*Z + costW*W;

solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), " W=", show(W), "\n",
  "minimum_total_daily_cost=", show(total_cost), "\n"
];