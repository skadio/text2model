% Parameters (with values embedded)
int: cost1 = 500;
int: cost2 = 400;
int: cost3 = 300;
int: cost4 = 200;

% Bounds on allocations (not specified explicitly in the description; use non-negative integers)
int: LB = 0;
int: UB = 100000; % sufficiently large safe upper bound

% Variables
var LB..UB: X1;
var LB..UB: X2;
var LB..UB: X3;
var LB..UB: X4;

var int: total_cost = cost1*X1 + cost2*X2 + cost3*X3 + cost4*X4;

% Constraints
constraint X1 + X2 <= 1000;
constraint 2*X2 + X3 >= 800;
constraint 2*X1 <= X3;              % X1 can't exceed half of X3
constraint X4 <= X1 - 200;          % X4 at least 200 fewer than X1
constraint X4 <= X2 - 150;          % X4 at least 150 fewer than X2

% Objective
solve minimize total_cost;

output [
  "X1=", show(X1), "\n",
  "X2=", show(X2), "\n",
  "X3=", show(X3), "\n",
  "X4=", show(X4), "\n",
  "total_cost=", show(total_cost), "\n"
];