% Resource allocation for projects X, Y, Z (integer units)
% Minimize total cost subject to linear constraints.

int: total_limit = 100;
int: min_req = 50;     % 2*X + Y >= 50
int: max_xz = 70;      % X + Z <= 70

int: costX = 50;
int: costY = 30;
int: costZ = 20;

var 0..total_limit: X;
var 0..total_limit: Y;
var 0..total_limit: Z;

% Constraints
constraint X + Y + Z <= total_limit;
constraint 2*X + Y >= min_req;
constraint X + Z <= max_xz;

% Objective
var int: totalCost = costX*X + costY*Y + costZ*Z;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost = ", show(totalCost), "\n"
];