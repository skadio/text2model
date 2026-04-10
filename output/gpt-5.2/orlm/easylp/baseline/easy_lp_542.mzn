% Resource allocation minimization for projects X, Y, Z (all data embedded)

int: TOTAL_MAX = 100;

int: X_min = 0;  int: X_max = 50;
int: Y_min = 0;  int: Y_max = 60;
int: Z_min = 0;  int: Z_max = 70;

int: costX = 1000;
int: costY = 2000;
int: costZ = 3000;

var X_min..X_max: X;
var Y_min..Y_max: Y;
var Z_min..Z_max: Z;

constraint X + Y + Z <= TOTAL_MAX;
constraint 2*X + Y >= 30;
constraint X + Z >= 40;

var int: total_cost = costX*X + costY*Y + costZ*Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "min_total_cost_dollars=", show(total_cost), "\n"
];