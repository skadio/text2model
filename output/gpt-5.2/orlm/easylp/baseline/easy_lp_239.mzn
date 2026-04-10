% Resource allocation for projects X, Y, Z (integer units)
var 0..1000: X;
var 0..1000: Y;
var 0..1000: Z;

% Budget constraint
constraint X + Y + Z <= 1000;

% Minimum operational requirement
constraint 3 * X + 2 * Y >= 400;

% Balanced distribution between Z and Y
constraint abs(Z - Y) <= 300;

% X must be greater than twice Z
constraint X > 2 * Z;

% Costs per unit
int: costX = 300;
int: costY = 500;
int: costZ = 200;

var int: TotalCost = costX * X + costY * Y + costZ * Z;

solve minimize TotalCost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "MinimumTotalCost=$", show(TotalCost), "\n"
];