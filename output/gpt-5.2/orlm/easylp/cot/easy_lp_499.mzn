% Parameters (with values embedded)
int: costX = 5000;
int: costY = 3000;

int: minTotal = 50;
int: max2XplusY = 120;
int: minXminus3Y = 10;

int: minX = 20;
int: minY = 10;

% Upper bounds implied by constraints (for tighter domains)
int: maxX = 60;  % from 2X + Y <= 120 and Y >= 10 => X <= 55, but keep safe
int: maxY = 80;  % from 2X + Y <= 120 and X >= 20 => Y <= 80

% Variables
var minX..maxX: X;  % residential units (integer)
var minY..maxY: Y;  % commercial units (integer)

% Constraints
constraint X + Y >= minTotal;
constraint 2*X + Y <= max2XplusY;
constraint X - 3*Y >= minXminus3Y;

% Objective
var int: totalCost = costX*X + costY*Y;
solve minimize totalCost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Minimum total investment cost=$", show(totalCost), "\n"
];