% Marketing campaign cost minimization (all data embedded)

% Data
int: costX = 5;
int: costY = 3;
int: minEffect = 1000;
int: maxImbalance = 500;

% Decision variables (integer units)
var 0..1000000: X;
var 0..1000000: Y;

% Constraints
constraint X + Y >= minEffect;

% |X - 2Y| <= 500
constraint X - 2*Y <= maxImbalance;
constraint 2*Y - X <= maxImbalance;

% Objective: minimize total cost
var 0..intmax: totalCost = costX * X + costY * Y;
solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum cost (nearest dollar) = $", show(totalCost), "\n"
];