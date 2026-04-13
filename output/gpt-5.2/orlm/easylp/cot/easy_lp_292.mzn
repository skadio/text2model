% Parameters (with values embedded)
int: total_budget = 100;
int: yz_cap = 70;

int: costX = 3;
int: costY = 2;
int: costZ = 5;

int: X_min = 0;
int: X_max = 50;
int: Y_min = 0;
int: Y_max = 30;

% From constraints: X + Y + Z <= 100 and X,Y >= 0, so Z <= 100
int: Z_min = 0;
int: Z_max = total_budget;

% Variables
var X_min..X_max: X;
var Y_min..Y_max: Y;
var Z_min..Z_max: Z;

var 0..(costX*X_max + costY*Y_max + costZ*Z_max): total_cost;

% Constraints
constraint X + Y + Z <= total_budget;
constraint X >= 2 * Y + 10;
constraint Y + Z <= yz_cap;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "min_total_cost=", show(total_cost), "\n"
];