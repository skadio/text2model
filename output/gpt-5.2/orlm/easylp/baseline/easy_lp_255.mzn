% Supply chain resource allocation (integer)
% Minimize total cost: 5*x1 + 4*x2 + 6*x3

int: c1 = 5;
int: c2 = 4;
int: c3 = 6;

% Bounds (not specified in the description, so we assume nonnegative allocations)
int: U = 1000; % safe upper bound to keep the model finite
var 0..U: x1;
var 0..U: x2;
var 0..U: x3;

% Constraints
constraint x1 + x2 <= 100;
constraint 2*x1 + 3*x3 >= 150;
constraint 4*x2 - x3 <= 200;

var int: total_cost = c1*x1 + c2*x2 + c3*x3;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "total_cost=", show(total_cost), "\n"
];