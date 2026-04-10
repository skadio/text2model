% Resource allocation among departments X, Y, Z
% Minimize cost subject to integer allocations and constraints.

int: total_resources = 100;

int: costX = 5;
int: costY = 3;
int: costZ = 7;

var 0..total_resources: X;
var 0..total_resources: Y;
var 0..total_resources: Z;

% Total available resources (can be less than or equal to 100)
constraint X + Y + Z <= total_resources;

% X requires at least 10 more units than half of Y: X >= Y/2 + 10
% Multiply by 2 to avoid fractions: 2X >= Y + 20
constraint 2 * X >= Y + 20;

% Combined allocation for Y and Z cannot exceed 60
constraint Y + Z <= 60;

var 0..1000000: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "TotalCost = ", show(total_cost), "\n"
];