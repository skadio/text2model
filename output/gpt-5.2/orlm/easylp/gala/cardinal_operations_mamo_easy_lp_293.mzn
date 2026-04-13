include "globals.mzn";

% Decision variables: number of students enrolled in each course (nonnegative integers)
var 0..30: X;
var 0..20: Y;
var 0..20: Z;

% Constraints
constraint X + Y <= 30;      % classroom capacity for X and Y
constraint Y + Z <= 20;      % faculty availability for Y and Z
constraint X + Z >= 10;      % diversity requirement for X and Z

% Objective: minimize total operational cost
var int: total_cost = 5*X + 3*Y + 1*Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];