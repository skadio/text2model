% Restocking optimization for two product categories X and Y (integers)

% Decision variables (nonnegative integers)
var 0..100: x;  % units of category X
var 0..100: y;  % units of category Y

% Constraints
constraint x + 3*y >= 10;   % minimum inventory score
constraint 2*x + y <= 15;   % storage limitation

% Objective: minimize total cost
var int: cost = 4*x + 5*y;
solve minimize cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_cost = ", show(cost), "\n"
];