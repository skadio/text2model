int: total_space = 1000;

int: min_X = 200;
int: min_Y = 150;
int: min_Z = 100;

int: cost_per_m2_X = 5;
int: cost_per_m2_Y = 3;
int: cost_per_m2_Z = 2;

var min_X..total_space: X;
var min_Y..total_space: Y;
var min_Z..total_space: Z;

constraint X + Y + Z <= total_space;

var int: total_cost = cost_per_m2_X * X + cost_per_m2_Y * Y + cost_per_m2_Z * Z;

solve minimize total_cost;

output [
  "X=", show(X), " m2\n",
  "Y=", show(Y), " m2\n",
  "Z=", show(Z), " m2\n",
  "TotalAllocated=", show(X+Y+Z), " m2\n",
  "MinimumTotalCost=$", show(total_cost), "\n"
];