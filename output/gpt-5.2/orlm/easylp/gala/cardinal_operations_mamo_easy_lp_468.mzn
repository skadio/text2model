% Budget allocation for two projects (all data embedded)

% Parameters
int: B = 100;        % total budget cannot exceed 100 units
int: minX = 30;      % minimum investment in X
int: minY = 20;      % minimum investment in Y
int: costX = 50;     % cost per unit in X
int: costY = 60;     % cost per unit in Y

% Decision variables (whole-number investments)
var minX..B: x;
var minY..B: y;

% Constraints
constraint x + y <= B;

% Objective: minimize total cost
var int: totalCost = costX * x + costY * y;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "Minimum total cost (rounded) = ", show(totalCost), "\n"
];