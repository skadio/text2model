% Real estate development cost minimization (all data embedded)

int: max_total_properties = 1000;

int: min_X = 400; % single-family homes
int: min_Y = 250; % multi-family homes
int: min_Z = 350; % commercial buildings

int: cost_X = 200000; % dollars
int: cost_Y = 300000; % dollars
int: cost_Z = 150000; % dollars

var int: X >= min_X;
var int: Y >= min_Y;
var int: Z >= min_Z;

constraint X + Y + Z <= max_total_properties;

var int: total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

solve minimize total_cost;

output [
  "X(single-family) = ", show(X), "\n",
  "Y(multi-family)  = ", show(Y), "\n",
  "Z(commercial)    = ", show(Z), "\n",
  "Minimum total construction cost ($) = ", show(total_cost), "\n"
];