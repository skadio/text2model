% Tourism agency resource allocation (integer linear minimization)

% Data (embedded as requested)
int: c1 = 100;
int: c2 = 200;
int: c3 = 300;
int: c4 = 400;

int: ub12 = 500;
int: ub34 = 600;

% Decision variables: allocations must be whole numbers
var 0..ub12: x1;
var 0..ub12: x2;
var 0..ub34: x3;
var 0..ub34: x4;

% Constraints
constraint x1 + x2 <= 500;
constraint x3 + x4 <= 600;
constraint x1 + x3 >= 300;
constraint x2 + x4 >= 400;

% Objective: minimize total cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];