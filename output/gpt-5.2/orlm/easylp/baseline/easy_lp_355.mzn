% Resource allocation for four departments: x1, x2, x3, x4
% Minimize total cost with embedded data

% Bounds (not specified in the description).
% Use broad nonnegative bounds that safely allow feasibility.
int: UB = 1000;

var 0..UB: x1;
var 0..UB: x2;
var 0..UB: x3;
var 0..UB: x4;

% Constraints
constraint 2*x1 + 3*x2 <= 150;
constraint x1 + x4 >= 30;
constraint abs(x3 - x4) <= 10;
constraint 4*x1 + 5*x2 + x3 >= 80;

% Objective: minimize cost
var int: total_cost = 5*x1 + 3*x2 + 2*x3 + 7*x4;
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "min_total_cost=", show(total_cost), "\n",
  "min_total_cost_rounded=", show(total_cost), "\n"
];