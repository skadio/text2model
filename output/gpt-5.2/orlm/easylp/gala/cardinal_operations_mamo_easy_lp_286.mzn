% Tourism marketing budget allocation (integer units)
include "globals.mzn";

% Data (embedded as required)
int: costX = 10;
int: costY = 15;
int: costZ = 20;

int: maxXY = 100;
int: maxYZ = 150;
int: minXZ = 50;

% Decision variables: integer investment units in each destination
% Upper bounds are chosen safely from constraints (and could be larger without changing correctness).
var 0..100: x;
var 0..150: y;
var 0..150: z;

% Constraints
constraint x + y <= maxXY;
constraint y + z <= maxYZ;
constraint x + z >= minXZ;

% Objective: minimize total expenditure
var int: total_cost = costX * x + costY * y + costZ * z;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "total_cost = ", show(total_cost), "\n"
];