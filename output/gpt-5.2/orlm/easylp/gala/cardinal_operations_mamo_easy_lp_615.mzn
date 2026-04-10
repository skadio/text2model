include "globals.mzn";

/% Problem data (embedded) %/
int: c1 = 500;
int: c2 = 400;
int: c3 = 300;
int: c4 = 200;

/% Decision variables: whole-number resource allocations %/
var 0..10000: X1;
var 0..10000: X2;
var 0..10000: X3;
var 0..10000: X4;

/% Constraints %/
constraint X1 + X2 <= 1000;
constraint 2 * X2 + X3 >= 800;
constraint 2 * X1 <= X3;          % X1 <= 0.5 * X3
constraint X4 <= X1 - 200;        % at least 200 fewer than X1
constraint X4 <= X2 - 150;        % at least 150 fewer than X2

/% Objective: minimize total cost %/
var int: totalCost = c1*X1 + c2*X2 + c3*X3 + c4*X4;

solve minimize totalCost;

output [
  "X1=", show(X1), " X2=", show(X2), " X3=", show(X3), " X4=", show(X4), "\n",
  "TotalCost=", show(totalCost), "\n"
];