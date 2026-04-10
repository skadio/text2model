% Resource allocation for projects X, Y, Z (integer units)
% Minimize total cost with linear constraints.

include "globals.mzn";

% Data (embedded as requested)
int: costX = 50;
int: costY = 60;
int: costZ = 70;

int: xMax = 200;
int: yMax = 150;
int: zMax = 300;

int: minConstraint1 = 500;
int: maxConstraint2 = 800;
int: minConstraint3 = 100;

% Decision variables
var 0..xMax: x;
var 0..yMax: y;
var 0..zMax: z;

% Constraints
% 2x + 3y + z >= 500
constraint 2*x + 3*y + z >= minConstraint1;

% x + y + 4z <= 800
constraint x + y + 4*z <= maxConstraint2;

% (x - y) + z >= 100
constraint x - y + z >= minConstraint3;

% Objective: minimize total cost
var int: total_cost = costX*x + costY*y + costZ*z;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "minimum total cost ($) = ", show(total_cost), "\n"
];