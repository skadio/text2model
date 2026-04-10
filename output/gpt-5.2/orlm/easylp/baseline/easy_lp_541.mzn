int: max_total = 1000;

int: c1 = 500;
int: c2 = 600;
int: c3 = 700;

% Bounds (not explicitly given; use natural nonnegative bounds plus total limit)
var 0..max_total: x1;
var 0..max_total: x2;
var 0..max_total: x3;

% Total allocation limit
constraint x1 + x2 + x3 <= max_total;

% 2*x1 - 0.5*x2 >= 200  ->  4*x1 - x2 >= 400 (avoid fractions)
constraint 4 * x1 - x2 >= 400;

% 2*x3 - x1 <= 300
constraint 2 * x3 - x1 <= 300;

var int: total_cost = c1 * x1 + c2 * x2 + c3 * x3;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "min_total_cost=$", show(total_cost), "\n"
];