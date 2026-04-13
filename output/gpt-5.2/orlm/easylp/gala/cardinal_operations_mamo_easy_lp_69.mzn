% Crop planting cost minimization (integer linear program)

% Data (embedded as per instruction)
int: costX = 5;
int: costY = 10;

int: minQuota = 200;   % 2*X + Y >= 200
int: maxCap   = 150;   % X + 3*Y <= 150

% Decision variables (nonnegative integers)
var 0..1000: X;
var 0..1000: Y;

% Constraints
constraint 2*X + Y >= minQuota;
constraint X + 3*Y <= maxCap;

% Objective
var int: totalCost = costX*X + costY*Y;
solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost = ", show(totalCost), "\n"
];