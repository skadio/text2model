% Telecom resource allocation ILP (all data embedded)

% Decision variables: whole-number resource units allocated to projects X, Y, Z
var 0..100: X;
var 0..100: Y;
var 0..100: Z;

% Constraints
constraint 2*X + 3*Y + Z >= 10;
constraint X - Y + Z <= 8;
constraint Y - Z >= 3;

% Objective: minimize total cost ($5 for X, $4 for Y, $6 for Z)
var int: total_cost = 5*X + 4*Y + 6*Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];