% Environmental projects funding optimization (integer linear programming)
% Embed all data directly as per instructions.

int: costX = 100;
int: costY = 200;

int: xMin = 0;  int: xMax = 30;
int: yMin = 0;  int: yMax = 20;

int: totalMax = 50;

% Decision variables: integer units of funding
var xMin..xMax: x;
var yMin..yMax: y;

% Constraints
constraint x + y <= totalMax;
constraint 3 * x - y >= 10;

% Objective: minimize total cost in dollars
var int: totalCost = costX * x + costY * y;

solve minimize totalCost;

output [
  "x (Project X units) = ", show(x), "\n",
  "y (Project Y units) = ", show(y), "\n",
  "Minimum total cost ($) = ", show(totalCost), "\n"
];