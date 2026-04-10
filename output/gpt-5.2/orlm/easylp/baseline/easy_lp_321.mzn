% Cargo allocation among ships X, Y, Z (all data embedded)

int: costX = 5;
int: costY = 7;
int: costZ = 3;

int: maxX = 100;
int: maxY = 80;
int: maxZ = 60;

var 0..maxX: x;
var 0..maxY: y;
var 0..maxZ: z;

% Constraints
constraint 2*x + 3*y + z >= 30;
constraint x + 4*y + 2*z <= 50;
constraint x - y + z >= 10;

% Objective: minimize total cost
var int: total_cost = costX*x + costY*y + costZ*z;
solve minimize total_cost;

% Output: minimum total cost (already an integer, so rounding is implicit)
output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "min_total_cost=", show(total_cost), "\n"
];