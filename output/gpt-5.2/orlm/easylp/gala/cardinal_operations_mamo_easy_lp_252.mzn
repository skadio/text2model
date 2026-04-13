% Supply chain resource allocation (integer linear optimization)

% Decision variables: whole-number allocations
var 0..10000: X;  % procurement
var 0..10000: Y;  % manufacturing
var 0..10000: Z;  % distribution

% Constraints
constraint X + Y <= 1000;
constraint Y + Z >= 500;
constraint abs(X - Z) <= 200;

% Objective: minimize total cost
var int: total_cost = 4*X + 3*Y + 2*Z;
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];