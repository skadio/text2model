% Military logistics allocation (embedded data)

% Parameters (from description)
int: min_units = 10;
int: max_firepower = 50;

int: fpX = 5;
int: fpY = 3;

int: costX = 1000;
int: costY = 2000;

% Decision variables (whole numbers)
var 0..50: x;   % number of unit X
var 0..50: y;   % number of unit Y

% Constraints
constraint x + y >= min_units;
constraint fpX * x + fpY * y <= max_firepower;

% Objective: minimize total support points
var int: total_cost = costX * x + costY * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_support_points = ", show(total_cost), "\n"
];