% Environmental projects cost minimization with embedded data

int: costX = 1000;
int: costY = 500;
int: costZ = 1200;

int: totalMax = 100;

% Allocation bounds
int: Xmin = 0;  int: Xmax = 50;
int: Ymin = 0;  int: Ymax = 40;
int: Zmin = 0;  int: Zmax = 60;

% Decision variables (whole numbers)
var Xmin..Xmax: X;
var Ymin..Ymax: Y;
var Zmin..Zmax: Z;

% Constraints
constraint X + Y + Z <= totalMax;
constraint X >= Y + 10;
constraint Z <= Y + 20;

% Objective: minimize total cost
var int: totalCost = costX * X + costY * Y + costZ * Z;
solve minimize totalCost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "Minimum total cost ($) = ", show(totalCost), "\n"
];