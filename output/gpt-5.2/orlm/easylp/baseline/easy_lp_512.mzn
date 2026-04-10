% Production planning MILP (all data embedded)

int: capacity = 1000;

int: minDemand = 300;              % 2*X + Y >= 300
int: materialLimit = 600;          % X + 3*Z <= 600

int: costX = 50;
int: costY = 30;
int: costZ = 20;

var 0..capacity: X;
var 0..capacity: Y;
var 0..capacity: Z;

constraint X + Y + Z <= capacity;
constraint 2*X + Y >= minDemand;
constraint X + 3*Z <= materialLimit;

var int: totalCost = costX*X + costY*Y + costZ*Z;

solve minimize totalCost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "min_total_cost=", show(totalCost), "\n"
];