% Manufacturing production planning - Integer Linear Optimization
% All data embedded as requested.

% Unit production costs
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;

% Decision variables: integer units produced
var int: x1;
var int: x2;
var int: x3;

% Bounds (not explicitly given beyond "specified bounds" in the text),
% so we impose natural non-negativity. Upper bounds are implied by constraints.
constraint x1 >= 0 /\ x2 >= 0 /\ x3 >= 0;

% Capacity / relationship constraints
constraint x1 + 2 * x2 <= 1000;
constraint 3 * x1 >= x3 + 300;
constraint 4 * x2 + x3 <= 1500;
constraint 5 * x2 - (x1 + x3) <= 70;

% Objective: minimize total cost
var int: total_cost = c1 * x1 + c2 * x2 + c3 * x3;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "total_cost = ", show(total_cost), "\n"
];