% Transportation resource allocation (integer linear optimization)
% All data embedded as requested.

int: CAP = 2000;

int: costX = 3;
int: costY = 2;
int: costZ = 1;

int: diffX_vs_2Y = 1000;  % |X - 2Y| >= 1000
int: diffZ_vs_Y  = 500;   % |Z - Y|  >= 500

% Decision variables: whole-number allocations (nonnegative)
var 0..CAP: X;
var 0..CAP: Y;
var 0..CAP: Z;

% Capacity constraint
constraint X + Y + Z <= CAP;

% Difference constraints
constraint abs(X - 2 * Y) >= diffX_vs_2Y;
constraint abs(Z - Y) >= diffZ_vs_Y;

% Objective: minimize total cost
var 0..(costX*CAP + costY*CAP + costZ*CAP): total_cost;
constraint total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost (rounded) = ", show(total_cost), "\n"
];