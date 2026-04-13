int: c1 = 5;
int: c2 = 10;
int: c3 = 20;
int: c4 = 25;

% Production bounds (not explicitly given; use nonnegative integers)
int: UB = 1000000;

var 0..UB: X1;
var 0..UB: X2;
var 0..UB: X3;
var 0..UB: X4;

% Objective: minimize total cost
var int: total_cost = c1*X1 + c2*X2 + c3*X3 + c4*X4;

constraint X1 + X2 <= 100;

% "For every 2 units of X3, 3 units of X4 can be made within a maximum limit of 200 units."
% Interpreted as ratio constraint with a shared capacity: 2*X3 + 3*X4 <= 200
constraint 2*X3 + 3*X4 <= 200;

constraint X1 - 2*X2 + X3 >= 50;

% "The difference between the numbers of products made for type-x2,x3, subtracted from type-x1, should not exceed 70."
% Interpreted as X1 - (X2 + X3) <= 70
constraint X1 - X2 - X3 <= 70;

solve minimize total_cost;

output [
  "X1=", show(X1), "\n",
  "X2=", show(X2), "\n",
  "X3=", show(X3), "\n",
  "X4=", show(X4), "\n",
  "total_cost=", show(total_cost), "\n"
];