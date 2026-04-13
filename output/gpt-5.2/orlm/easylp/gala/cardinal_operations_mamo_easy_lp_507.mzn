include "globals.mzn";

% Data (embedded from problem description)
int: BUDGET = 1000;

int: cX = 20;
int: cY = 30;
int: cZ = 40;

int: rhs1 = 300;  % for 2X - Y - Z >= 300
int: rhs2 = 200;  % for X - 3Y - Z = 200

% Decision variables (whole-number investment units)
var 0..BUDGET: X;
var 0..BUDGET: Y;
var 0..BUDGET: Z;

% Constraints
constraint X + Y + Z <= BUDGET;
constraint 2*X - Y - Z >= rhs1;
constraint X - 3*Y - Z = rhs2;

% Objective: minimize total cost
var 0..(cZ * BUDGET): total_cost = cX*X + cY*Y + cZ*Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "TotalCost = ", show(total_cost), "\n"
];