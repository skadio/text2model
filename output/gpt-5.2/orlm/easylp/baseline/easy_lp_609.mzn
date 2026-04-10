% Telecommunications resource allocation (all data embedded)

var 0..500: x1;
var 0..400: x2;
var 0..600: x3;
var 0..700: x4;

int: c1 = 1000;
int: c2 = 2000;
int: c3 = 3000;
int: c4 = 4000;

% Objective: minimize total cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Capacity constraints
constraint x1 + x2 <= 500;
constraint x3 + x4 <= 800;

% Balance constraints (avoid fractions by multiplying)
% "half of x1 must be at least one-fourth more than x3 by no less than 50 units"
% Interpreted as: (1/2)x1 >= (5/4)x3 + 50  =>  2*x1 >= 5*x3 + 200
constraint 2*x1 >= 5*x3 + 200;

% "difference between three-quarters of x4 and x2 must be at least 100"
% Interpreted as: (3/4)x4 - x2 >= 100  =>  3*x4 >= 4*x2 + 400
constraint 3*x4 >= 4*x2 + 400;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "min_total_cost_dollars=", show(total_cost), "\n"
];