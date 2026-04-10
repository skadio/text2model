% Investment allocation problem: minimize total costs

% Decision variables (whole dollars)
var 200..5000: X;
var 100..4000: Y;
var 800..10000: Z;

% Budget constraint
constraint X + Y + Z <= 10000;

% Return constraint:
% 7% return on X minus 2% loss on Y and 5% loss on Z must not be negative
% 0.07X - 0.02Y - 0.05Z >= 0
% Multiply by 100 to avoid decimals: 7X - 2Y - 5Z >= 0
constraint 7*X - 2*Y - 5*Z >= 0;

% Difference constraint: X - 2Y + Z >= 3000
constraint X - 2*Y + Z >= 3000;

% Objective: minimize total costs
% Costs per dollar invested: 50, 30, 20 for X, Y, Z
var int: total_cost = 50*X + 30*Y + 20*Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "total_cost = ", show(total_cost), "\n"
];