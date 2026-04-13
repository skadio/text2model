% Tourism tours optimization (embedded data)

% Data (from problem statement)
int: maxTours = 500;
int: minDiversity = 1000;     % 3*X + 2*Y >= 1000
int: maxDiff = 200;           % |X - Y| <= 200
int: costX = 50;
int: costY = 30;

% Decision variables (integers, nonnegative)
var 0..maxTours: X;
var 0..maxTours: Y;

% Constraints
constraint X + Y <= maxTours;
constraint 3*X + 2*Y >= minDiversity;
constraint abs(X - Y) <= maxDiff;

% Objective
var int: totalCost = costX*X + costY*Y;
solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "TotalCost = $", show(totalCost), "\n"
];