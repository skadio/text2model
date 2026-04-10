int: c1 = 4;
int: c2 = 3;
int: c3 = 5;
int: c4 = 6;

% Decision variables (integer resource allocations)
var int: X1;
var int: X2;
var int: X3;
var int: X4;

% Objective: minimize total cost
var int: total_cost = c1*X1 + c2*X2 + c3*X3 + c4*X4;

constraint X1 + X2 <= 1000;
constraint 2*X2 + X3 >= 500;

% (1/2)X3 - X1 <= 200  ->  X3 - 2*X1 <= 400
constraint X3 - 2*X1 <= 400;

% X4 - X2 >= -400  ->  X2 - X4 <= 400
constraint X2 - X4 <= 400;

% 0.8*X4 - X3 <= -300  ->  8*X4 - 10*X3 <= -3000
constraint 8*X4 - 10*X3 <= -3000;

% Implicit bounds to avoid unbounded minimization (nonnegative allocations)
constraint X1 >= 0;
constraint X2 >= 0;
constraint X3 >= 0;
constraint X4 >= 0;

solve minimize total_cost;

output [
  "X1=", show(X1), "\n",
  "X2=", show(X2), "\n",
  "X3=", show(X3), "\n",
  "X4=", show(X4), "\n",
  "Minimum total cost (rounded) = ", show(total_cost), "\n"
];