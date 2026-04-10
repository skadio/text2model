int: c1 = 10;
int: c2 = 15;
int: c3 = 20;
int: c4 = 25;

% Bounds (not provided in the description, so we use natural nonnegativity)
int: LB = 0;
int: UB = 1000000;

var LB..UB: x1;
var LB..UB: x2;
var LB..UB: x3;
var LB..UB: x4;

% Constraints
constraint x1 + x2 <= 1000;
constraint 2*x3 + 3*x4 <= 1500;
constraint x2 - (x1 + x3) >= 300;
constraint x3 - (x2 + x4) <= 500;

% Objective: minimize total cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];