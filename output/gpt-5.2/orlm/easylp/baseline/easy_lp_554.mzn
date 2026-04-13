% Workforce allocation among departments X, Y, Z
% Minimize total cost subject to staffing and total headcount constraints.

int: max_total = 100;

int: min_X = 20;
int: min_Y = 30;
int: min_Z = 10;

int: cost_X = 5000;
int: cost_Y = 4000;
int: cost_Z = 6000;

var min_X..max_total: X;
var min_Y..max_total: Y;
var min_Z..max_total: Z;

constraint X + Y + Z <= max_total;

var int: total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "Minimum total cost (rounded to nearest dollar) = $", show(total_cost), "\n"
];