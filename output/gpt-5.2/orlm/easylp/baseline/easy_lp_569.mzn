% Environmental projects resource allocation (integer)
% Minimize total cost: 4*X1 + 5*X2 + 6*X3
% Subject to:
%   X1 + 2*X2 <= 1000
%   X2 + 3*X3 >= 600
%   2*X3 - X1 = 500
%   X1, X2, X3 are whole numbers (integers)

int: c1 = 4;
int: c2 = 5;
int: c3 = 6;

var int: X1;
var int: X2;
var int: X3;

constraint X1 + 2*X2 <= 1000;
constraint X2 + 3*X3 >= 600;
constraint 2*X3 - X1 = 500;

% Implicit nonnegativity to model "resource allocations"
constraint X1 >= 0;
constraint X2 >= 0;
constraint X3 >= 0;

var int: total_cost = c1*X1 + c2*X2 + c3*X3;

solve minimize total_cost;

output [
  "X1 = ", show(X1), "\n",
  "X2 = ", show(X2), "\n",
  "X3 = ", show(X3), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];