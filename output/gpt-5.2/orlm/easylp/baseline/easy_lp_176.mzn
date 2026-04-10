% Energy investment allocation across projects X, Y, Z
% Minimize total cost subject to pairwise investment constraints and bounds.
% All data embedded.

int: costX = 10;
int: costY = 15;
int: costZ = 20;

var 0..2000: X;
var 0..1500: Y;
var 0..2500: Z;

% Constraints
constraint X + Y <= 5000;
constraint Y + Z >= 3000;
constraint X + Z <= 4000;

var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total investment cost = ", show(total_cost), "\n"
];