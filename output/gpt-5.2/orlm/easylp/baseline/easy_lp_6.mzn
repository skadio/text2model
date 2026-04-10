% Marketing campaign cost minimization (all data embedded)

int: costX = 5;
int: costY = 3;

int: min_effectiveness = 1000;
int: max_balance_diff = 500;

% Decision variables: integer units allocated to channels X and Y
var 0..1000000: X;
var 0..1000000: Y;

% Total effectiveness constraint
constraint X + Y >= min_effectiveness;

% Balance constraint: |X - 2Y| <= 500
constraint abs(X - 2*Y) <= max_balance_diff;

% Objective: minimize total cost
var int: total_cost = costX*X + costY*Y;
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum cost (nearest dollar) = $", show(total_cost), "\n"
];