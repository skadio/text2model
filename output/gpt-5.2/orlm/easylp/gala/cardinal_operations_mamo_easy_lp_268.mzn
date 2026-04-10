% HR staff allocation across departments X, Y, Z
% All data embedded as requested.

include "globals.mzn";

% Parameters
int: maxEmployees = 100;
int: costX = 5000;
int: costY = 4000;
int: costZ = 6000;

% Decision variables: number of employees in each department
var 0..maxEmployees: x;
var 0..maxEmployees: y;
var 0..maxEmployees: z;

% Constraints
constraint x + y + z <= maxEmployees;

% "X at least twice the half of Y"  => x >= 2*(y/2) = y
constraint x >= y;

% "Z should not exceed by more than 10 the three-fourths of X"
% z <= (3/4)*x + 10  <=> 4z <= 3x + 40
constraint 4*z <= 3*x + 40;

% Objective: minimize total cost
var int: totalCost = costX*x + costY*y + costZ*z;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "totalCost = ", show(totalCost), "\n"
];