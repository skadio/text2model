% Telecom resource allocation (integer linear optimization)

% Data (embedded as requested)
int: c1 = 5;
int: c2 = 4;
int: c3 = 3;

int: x1_min = 0; int: x1_max = 500;
int: x2_min = 0; int: x2_max = 300;
int: x3_min = 0; int: x3_max = 400;

% Decision variables (whole-number allocations)
var x1_min..x1_max: x1;
var x2_min..x2_max: x2;
var x3_min..x3_max: x3;

% Constraints
constraint x1 + 2 * x2 <= 1000;
constraint 3 * x1 - x2 + x3 >= 500;
constraint -x1 + 4 * x2 - 2 * x3 = 200;

% Objective: minimize total cost
var int: total_cost = c1 * x1 + c2 * x2 + c3 * x3;
solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];