% Parameters (with values embedded)
int: minX = 5000;
int: minY = 2000;
int: maxTotal = 10000;

% Use cents to avoid floating point:
% Interest constraint: 0.07*X + 0.08*Y >= 700
% Multiply by 100: 7*X + 8*Y >= 70000
int: interestRHS = 70000;

% Transaction costs per dollar:
% X: $0.01 -> 1 cent per dollar
% Y: $0.02 -> 2 cents per dollar
int: costX_cents = 1;
int: costY_cents = 2;

% Variables
var minX..maxTotal: X;
var minY..maxTotal: Y;

% Total cost in cents (upper bound from max investments)
var 0..(costX_cents*maxTotal + costY_cents*maxTotal): total_cost_cents;

% Constraints
constraint X >= minX;
constraint Y >= minY;
constraint X + Y <= maxTotal;

constraint 7*X + 8*Y >= interestRHS;

constraint total_cost_cents = costX_cents*X + costY_cents*Y;

% Objective
solve minimize total_cost_cents;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total transaction cost = $",
  show(total_cost_cents div 100), ".",
  if (total_cost_cents mod 100) < 10 then "0" else "" endif,
  show(total_cost_cents mod 100), "\n"
];