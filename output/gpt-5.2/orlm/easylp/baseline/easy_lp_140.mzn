% Military logistics resource allocation (all data embedded)

% Decision variables: number of units of type X and Y (nonnegative integers)
var 0..1000: X;
var 0..1000: Y;

% Constraints
constraint 2 * X + 3 * Y <= 50;
constraint 5 * X + 1 * Y >= 10;
constraint abs(X - Y) <= 5;

% Costs are given in thousands of dollars:
% X costs 10 (=$10000), Y costs 20 (=$20000)
int: costX = 10;
int: costY = 20;

var int: total_cost = costX * X + costY * Y;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "min_total_cost_thousands=", show(total_cost), "\n"
];