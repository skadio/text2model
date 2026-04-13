include "globals.mzn";

% Departments:
% X = Math, Y = Science, Z = Arts

% Decision variables: number of teachers (whole numbers)
var 0..100: X;
var 0..100: Y;
var 0..100: Z;

% Constraints
constraint X + Y <= 25;
constraint X + Z >= 15;
constraint Y + Z <= 20;

% Objective: minimize total cost
var int: total_cost = 4*X + 3*Y + 2*Z;

solve minimize total_cost;

output [
  "X(Math) = ", show(X), "\n",
  "Y(Science) = ", show(Y), "\n",
  "Z(Arts) = ", show(Z), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];