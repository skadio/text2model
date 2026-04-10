% Tourism tours cost minimization (all data embedded)

var int: X; % number of type X tours
var int: Y; % number of type Y tours

constraint X >= 0 /\ Y >= 0;

% Total tours limit
constraint X + Y <= 500;

% Diversity objective: 3X + 2Y at least 1000
constraint 3*X + 2*Y >= 1000;

% Balance constraint: difference should not exceed 200
constraint abs(X - Y) <= 200;

% Costs
int: costX = 50;
int: costY = 30;

var int: total_cost = costX*X + costY*Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost (USD) = ", show(total_cost), "\n"
];