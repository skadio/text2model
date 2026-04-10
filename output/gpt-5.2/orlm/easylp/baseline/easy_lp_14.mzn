% Energy production allocation (embedded data)

int: costX = 50;
int: costY = 70;

int: demand = 5000;

int: emX = 10;
int: emY = 15;
int: emCap = 80000;

% Decision variables (integer units produced)
var 0..demand: X;
var 0..demand: Y;

% Constraints
constraint X + Y >= demand;
constraint emX * X + emY * Y <= emCap;

% Objective: minimize total cost
var int: totalCost = costX * X + costY * Y;
solve minimize totalCost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "totalCost=", show(totalCost), "\n"
];