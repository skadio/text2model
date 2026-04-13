% Production planning for products X, Y, Z

var 0..1000: X;
var 0..1000: Y;
var 0..1000: Z;

% Capacity constraint
constraint X + Y + Z <= 1000;

% Demand constraints
constraint 2*X + Y >= 500;  % X counted double due to complexity
constraint X + Z >= 400;    % balanced inventory requirement

% Cost minimization
var int: total_cost = 2*X + 3*Y + 4*Z;
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];