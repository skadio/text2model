% HR staffing allocation: minimize monthly cost subject to difference and capacity constraints.

include "globals.mzn";

% Embedded data (from problem statement)
int: total_cap = 1000;

int: capX = 500;
int: capY = 400;
int: capZ = 300;

int: costX = 50;
int: costY = 60;
int: costZ = 70;

int: diffXY = 200; % X >= Y + 200
int: diffYZ = 100; % Y >= Z + 100

% Decision variables (whole employees)
var 0..capX: X;
var 0..capY: Y;
var 0..capZ: Z;

% Constraints
constraint X + Y + Z <= total_cap;
constraint X >= Y + diffXY;
constraint Y >= Z + diffYZ;

% Objective: minimize total monthly cost
var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "TotalCost = ", show(total_cost), "\n"
];