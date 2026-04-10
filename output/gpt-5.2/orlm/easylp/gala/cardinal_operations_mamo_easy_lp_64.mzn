% Resource allocation between two projects (integer linear optimization)

int: costX = 500;
int: costY = 700;

int: effortX = 2;
int: effortY = 3;

int: minEffort = 2000;
int: maxResources = 1500;

% Decision variables: whole-number resource units allocated
var 0..maxResources: x;  % Project X
var 0..maxResources: y;  % Project Y

% Constraints
constraint effortX * x + effortY * y >= minEffort;
constraint x + y <= maxResources;

% Objective: minimize total cost
var int: totalCost = costX * x + costY * y;

solve minimize totalCost;

output [
  "x(Project X) = ", show(x), "\n",
  "y(Project Y) = ", show(y), "\n",
  "Minimum total cost = $", show(totalCost), "\n"
];