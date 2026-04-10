% Supply chain production planning (integer linear optimization)

% Data (embedded as requested)
int: costX = 10;
int: costY = 15;

% Demand constraint: 2*X + 3*Y >= 40
int: a1 = 2;
int: b1 = 3;
int: rhs1 = 40;

% Capacity constraint: 5*X + 4*Y <= 100
int: a2 = 5;
int: b2 = 4;
int: rhs2 = 100;

% Decision variables (whole numbers)
var 0..rhs2: X;
var 0..rhs2: Y;

% Constraints
constraint a1 * X + b1 * Y >= rhs1;
constraint a2 * X + b2 * Y <= rhs2;

% Objective: minimize total cost
var int: total_cost = costX * X + costY * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];