% Budget allocation across three portfolios X, Y, Z
% Minimize total cost subject to allocation constraints, all integer dollars.

int: BUDGET = 50000;

int: diff_XY = 10000;
int: diff_YZ = 5000;

int: costX = 1000;
int: costY = 800;
int: costZ = 600;

var 0..BUDGET: X;
var 0..BUDGET: Y;
var 0..BUDGET: Z;

constraint X + Y + Z <= BUDGET;
constraint X >= Y + diff_XY;
constraint Y >= Z + diff_YZ;

var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];