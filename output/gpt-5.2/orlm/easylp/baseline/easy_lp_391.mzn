% Fund allocation problem (integer linear optimization)

% Decision variables: allocations (whole numbers)
var int: x1;
var int: x2;
var int: x3;
var int: x4;

% Bounds not specified in the description; use nonnegative integer allocations
constraint x1 >= 0 /\ x2 >= 0 /\ x3 >= 0 /\ x4 >= 0;

% Constraints
constraint x1 + x2 >= 20;          % programs x1 and x2 at least 20
constraint x3 + x4 <= 40;          % programs x3 and x4 at most 40
constraint x1 - 2*x3 >= 5;         % x1 - 2*x3 at least 5
constraint x4 - x2 <= 10;          % x4 - x2 at most 10

% Objective: minimize total cost
var int: total_cost = 10*x1 + 15*x2 + 25*x3 + 35*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];