% Resource allocation across locations X, Y, Z
% Minimize total cost subject to constraints

int: MAX_TOTAL = 5000;
int: MIN_XY = 2000;
int: MAX_YZ = 2500;

int: costX = 50;
int: costY = 30;
int: costZ = 20;

var 0..MAX_TOTAL: X;
var 0..MAX_TOTAL: Y;
var 0..MAX_TOTAL: Z;

% Total resources limit
constraint X + Y + Z <= MAX_TOTAL;

% Demand constraint for X and Y combined
constraint X + Y >= MIN_XY;

% "twice the allocation for location X than Y" interpreted as X = 2*Y
constraint X = 2 * Y;

% Capacity constraint for Y and Z combined
constraint Y + Z <= MAX_YZ;

var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "TotalCost=", show(total_cost), "\n"
];