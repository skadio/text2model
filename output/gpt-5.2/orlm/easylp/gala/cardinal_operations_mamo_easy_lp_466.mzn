% Hiring optimization: minimize total salary cost

% Embedded data (no .dzn expected)
int: costX = 5000;
int: costY = 3000;

int: maxTotal = 50;
int: minX = 20;
int: maxY = 15;

% Decision variables (whole numbers of employees)
var 0..maxTotal: x;  % employees in position X
var 0..maxTotal: y;  % employees in position Y

% Constraints
constraint x + y <= maxTotal;
constraint x >= minX;
constraint y <= maxY;

% Objective
var int: totalCost = costX * x + costY * y;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = $", show(totalCost), "\n"
];