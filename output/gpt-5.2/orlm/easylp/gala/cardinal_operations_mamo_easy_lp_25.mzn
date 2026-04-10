% Transportation vehicles cost minimization (all data embedded)

int: costX = 5;
int: costY = 10;

int: minX = 30;
int: minY = 20;

int: maxTotal = 100;

% Decision variables: number of vehicles of type X and Y (whole numbers)
var minX..maxTotal: X;
var minY..maxTotal: Y;

% Total vehicles constraint
constraint X + Y <= maxTotal;

% Objective: minimize daily operational cost
var int: totalCost = costX * X + costY * Y;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Total vehicles = ", show(X + Y), "\n",
  "Minimum daily cost = $", show(totalCost), "\n"
];