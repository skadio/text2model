% Resource allocation / cost minimization (all data embedded)

include "globals.mzn";

% Costs per unit
int: c1 = 500;
int: c2 = 600;
int: c3 = 800;
int: c4 = 700;

% Bounds on each department allocation (not provided explicitly in the prompt).
% Use nonnegative integer allocations.
int: lb = 0;
int: ub = 1000;

var lb..ub: x1;
var lb..ub: x2;
var lb..ub: x3;
var lb..ub: x4;

% Constraints
constraint x1 + x2 <= 100;
constraint x3 + x4 <= 50;

% "x3 at least twice of that reduced from x1" -> interpret as x3 >= 2*x1
constraint x3 >= 2 * x1;

% "x4 no less than three quarters of that reduced from x2" -> x4 >= 3/4 * x2
% Avoid fractions: 4*x4 >= 3*x2
constraint 4 * x4 >= 3 * x2;

% Rebalancing: (x3+x4) - (x1+x2) >= 30
constraint (x3 + x4) - (x1 + x2) >= 30;

% Objective: minimize total cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "total_cost = ", show(total_cost), "\n"
];