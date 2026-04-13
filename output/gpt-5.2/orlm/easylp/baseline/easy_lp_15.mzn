% Resource allocation between two projects X and Y (integer investments)

var int: X;  % units allocated to project X
var int: Y;  % units allocated to project Y

constraint X >= 0 /\ Y >= 0;

% Budget constraint: 4*X + Y <= 10
constraint 4 * X + Y <= 10;

% Strategic objective: X + 2*Y >= 6
constraint X + 2 * Y >= 6;

% Minimize total cost: 7 per unit of X, 3 per unit of Y
var int: total_cost = 7 * X + 3 * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];