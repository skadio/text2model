% Parameters (with values embedded)
int: CAP = 1000;
int: BAL_MIN = 200;
int: LIMIT_MAX = 500;

int: c1 = 5;
int: c2 = 8;
int: c3 = 6;

% Variables
var 0..CAP: X1;
var 0..CAP: X2;
var 0..CAP: X3;

var 0..(CAP * max([c1,c2,c3])): TotalCost;

% Constraints
constraint X1 + X2 + X3 <= CAP;
constraint 2 * X1 - 3 * X2 >= BAL_MIN;
constraint 4 * X3 - X1 <= LIMIT_MAX;

constraint TotalCost = c1 * X1 + c2 * X2 + c3 * X3;

% Objective
solve minimize TotalCost;

output [
  "X1=", show(X1), "\n",
  "X2=", show(X2), "\n",
  "X3=", show(X3), "\n",
  "MinTotalCost=$", show(TotalCost), "\n"
];