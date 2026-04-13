include "globals.mzn";

% Investments (whole numbers)
var 0..500: X;
var 0..500: Y;
var 0..500: Z;

% Constraints
constraint X + Y + Z <= 500;
constraint 2*X + 3*Y >= 400;
constraint abs(Y - Z) <= 150;
constraint X - Z >= 100;

% Cost to minimize
var int: total_cost = 50*X + 30*Y + 80*Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];