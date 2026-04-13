% Resource allocation between departments X and Y (integer units)
% Minimize total cost subject to linear constraints.

int: minReq = 10;
int: maxBudget = 30;

int: costX = 4;
int: costY = 5;

% Decision variables (whole units)
var 0..100: x;   % units to department X
var 0..100: y;   % units to department Y

% Constraints
constraint x + 3*y >= minReq;
constraint 2*x + y <= maxBudget;

% Objective: minimize total cost
var int: totalCost = costX * x + costY * y;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum total cost = ", show(totalCost), "\n"
];