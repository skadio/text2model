% Telecommunications resource allocation - embedded data

int: costX = 5;
int: costY = 4;
int: costZ = 6;

var int: X;
var int: Y;
var int: Z;

% Constraints
constraint 2*X + 3*Y + Z >= 10;
constraint X - Y + Z <= 8;
constraint Y - Z >= 3;

% Nonnegativity (resource allocations)
constraint X >= 0 /\ Y >= 0 /\ Z >= 0;

var int: total_cost = costX*X + costY*Y + costZ*Z;

solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "min_total_cost=$", show(total_cost), "\n"
];