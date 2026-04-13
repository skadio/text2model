% Reforestation project: choose integer counts of tree types X and Y
% Minimize total planting cost subject to constraints.

int: max_total = 50;
int: min_total = 30;

int: costX = 10;
int: costY = 20;

var 0..max_total: X;
var 0..max_total: Y;

% Space limitation
constraint X + Y <= max_total;

% Minimum total trees
constraint X + Y >= min_total;

% Biodiversity: at least twice as many X as Y
constraint X >= 2 * Y;

% Not more than 10 more X than Y
constraint X - Y <= 10;

var 0..100000: total_cost = costX * X + costY * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];