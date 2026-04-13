% Parameters (with values embedded)
int: costX = 5;
int: costY = 10;

int: capResource = 100;    % 2*X + 3*Y <= 100
int: minDemand = 50;       % 4*X + 1*Y >= 50

% Variables
var 0..100: x;             % units of product X (integer, nonnegative)
var 0..100: y;             % units of product Y (integer, nonnegative)

% Constraints
constraint 2*x + 3*y <= capResource;
constraint 4*x + y >= minDemand;

% Objective
var 0..(costX*100 + costY*100): totalCost;
constraint totalCost = costX*x + costY*y;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum total production cost = $", show(totalCost), "\n"
];