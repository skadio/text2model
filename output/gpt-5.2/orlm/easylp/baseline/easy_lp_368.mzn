% Construction projects resource allocation - Integer Linear Programming in MiniZinc
% Data embedded directly in the model.

int: c1 = 500;
int: c2 = 300;
int: c3 = 700;
int: c4 = 600;

% Decision variables: whole-number resource allocations with given upper bounds
var 0..50: X1;
var 0..60: X2;
var 0..40: X3;
var 0..30: X4;

% Constraints
constraint X1 + X2 <= 100;
constraint 2*X3 + X4 <= 120;
constraint X1 + X3 >= 60;
constraint X2 + X4 >= 80;

% Objective: minimize total cost
var int: TotalCost = c1*X1 + c2*X2 + c3*X3 + c4*X4;

solve minimize TotalCost;

output [
  "X1 = ", show(X1), "\n",
  "X2 = ", show(X2), "\n",
  "X3 = ", show(X3), "\n",
  "X4 = ", show(X4), "\n",
  "Minimum total cost (rounded to nearest dollar) = $", show(TotalCost), "\n"
];