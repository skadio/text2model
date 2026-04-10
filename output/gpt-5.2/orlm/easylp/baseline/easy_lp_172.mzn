% Marketing budget allocation optimization (all data embedded)

int: BUDGET = 5000;

int: costX = 50;
int: costY = 30;
int: costZ = 20;

int: minDiffXY = 1000;
int: maxAbsDiffZY = 1500;

var 0..BUDGET: X;
var 0..BUDGET: Y;
var 0..BUDGET: Z;

% Constraints
constraint X + Y + Z <= BUDGET;
constraint X >= Y + minDiffXY;
constraint abs(Z - Y) <= maxAbsDiffZY;

% Objective: minimize total cost
var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "Minimum total cost ($)=", show(total_cost), "\n"
];