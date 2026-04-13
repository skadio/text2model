% Shift scheduling / cost minimization (all data embedded)

include "globals.mzn";

% Parameters
int: maxTotal = 24;

int: costX = 8;
int: costY = 6;
int: costZ = 10;

int: maxX = 12;
int: maxY = 8;
int: maxZ = 6;

% Decision variables: number of shifts for each worker type (integers)
var 0..maxX: x;
var 0..maxY: y;
var 0..maxZ: z;

% Constraints
constraint x + y + z <= maxTotal;

% Skill requirement: X at least 2 more than Y
constraint x >= y + 2;

% Balance: |Y - Z| <= 4
constraint abs(y - z) <= 4;

% Objective: minimize total cost
var int: totalCost = costX * x + costY * y + costZ * z;

solve minimize totalCost;

output [
  "x (type X shifts) = ", show(x), "\n",
  "y (type Y shifts) = ", show(y), "\n",
  "z (type Z shifts) = ", show(z), "\n",
  "Minimum total cost (nearest unit) = ", show(totalCost), "\n"
];