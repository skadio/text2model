% Telecommunications resource allocation - MiniZinc model
% All data embedded as requested.

% Decision variables: whole-number resource allocations
var 0..100000: X;
var 0..100000: Y;
var 0..100000: Z;

% Constraints
constraint X + Y >= 1000;
constraint abs(Y - Z) <= 500;
constraint X + Z = 1500;

% Objective: minimize total cost
var 0..1000000000: total_cost = 8*X + 5*Y + 2*Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost (rounded) = ", show(total_cost), "\n"
];