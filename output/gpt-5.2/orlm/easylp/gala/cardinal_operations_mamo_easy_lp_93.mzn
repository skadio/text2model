% Supply chain distribution between warehouses X and Y
% All data embedded as per problem statement.

int: CAP = 1000;
int: DEMAND = 800;
int: BAL = 200;

int: costX = 2;
int: costY = 3;

% Decision variables (integers, nonnegative)
var 0..CAP: X;
var 0..CAP: Y;

% Constraints
constraint X + Y <= CAP;
constraint 2*X + Y >= DEMAND;
constraint abs(X - 2*Y) <= BAL;

% Objective: minimize total cost
var int: totalCost = costX * X + costY * Y;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost (rounded to nearest dollar) = ", show(totalCost), "\n"
];