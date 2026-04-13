% Parameters (with values embedded)
int: TOTAL_BUDGET = 1000;
int: MIN_DIFF_XY = 200;
int: MAX_Z = 300;

int: costX = 50;
int: costY = 30;
int: costZ = 20;

% Variables
var 0..TOTAL_BUDGET: X;
var 0..TOTAL_BUDGET: Y;
var 0..MAX_Z: Z;

var 0..(costX*TOTAL_BUDGET + costY*TOTAL_BUDGET + costZ*MAX_Z): total_cost;

% Constraints
constraint X + Y + Z = TOTAL_BUDGET;
constraint X >= Y + MIN_DIFF_XY;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];