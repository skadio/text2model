include "globals.mzn";

% Data (embedded as required)
int: total_limit = 1000;
int: capX = 500;
int: capY = 300;
int: capZ = 200;

int: costX = 10;
int: costY = 20;
int: costZ = 30;

int: min_diff_XY = 200;   % X >= Y + 200
int: max_diff_YZ = 150;   % |Y - Z| <= 150

% Decision variables: whole vehicles assigned to each route
var 0..capX: X;
var 0..capY: Y;
var 0..capZ: Z;

% Constraints
constraint X + Y + Z <= total_limit;
constraint X >= Y + min_diff_XY;
constraint abs(Y - Z) <= max_diff_YZ;

% Objective: minimize total operating cost
var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total operating cost (rounded) = ", show(total_cost), "\n"
];