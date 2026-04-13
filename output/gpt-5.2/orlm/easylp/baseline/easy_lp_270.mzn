% Hiring plan optimization (all data embedded)

int: costX = 5000;
int: costY = 6000;
int: costZ = 7000;

int: total_max = 100;

int: capX = 50;
int: capY = 30;
int: capZ = 20;

var 0..capX: X;
var 0..capY: Y;
var 0..capZ: Z;

constraint X + Y + Z <= total_max;

% Strategic priority constraints
constraint X >= 2 * Y + 10;
constraint Y >= Z + 5;

var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "TotalCost=", show(total_cost), "\n"
];