% Resource allocation between projects X and Y (integer units)
% Minimize total cost subject to contract and manpower constraints.

int: costX = 5000;
int: costY = 7000;

var 0..5: X;
var 0..4: Y;

% Contract strength requirement: 2*X + 3*Y >= 10
constraint 2*X + 3*Y >= 10;

% Manpower limit: X + Y <= 8
constraint X + Y <= 8;

% Balance requirement: Y at least one more than X
constraint Y >= X + 1;

var int: total_cost = costX * X + costY * Y;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "min_total_cost_dollars=", show(total_cost), "\n"
];