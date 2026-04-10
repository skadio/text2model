% Shipping distribution optimization (all data embedded)

int: costX = 5;
int: costY = 4;
int: costZ = 3;

int: maxXY = 20;
int: minYZ = 30;
int: maxDiffXZ = 10;

% Decision variables: number of packages to each region (nonnegative integers)
var 0..1000: x;
var 0..1000: y;
var 0..1000: z;

% Constraints
constraint x + y <= maxXY;
constraint y + z >= minYZ;
constraint abs(x - z) <= maxDiffXZ;

% Objective: minimize total cost
var int: total_cost = costX*x + costY*y + costZ*z;
solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "z=", show(z), "\n",
  "min_total_cost=$", show(total_cost), "\n",
  "rounded_up=$", show(total_cost), "\n"
];