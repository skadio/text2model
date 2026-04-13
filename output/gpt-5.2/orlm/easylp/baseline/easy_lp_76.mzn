% Resource allocation between two project types (X and Y)

int: max_total_projects = 50;
int: min_diversity = 30;          % 2*X + Y >= 30
int: max_diff = 10;               % |X - Y| <= 10

int: max_X = 40;
int: max_Y = 20;

int: cost_X = 2000;
int: cost_Y = 3000;

var 0..max_X: X;
var 0..max_Y: Y;

constraint X + Y <= max_total_projects;
constraint 2*X + Y >= min_diversity;
constraint abs(X - Y) <= max_diff;

var int: total_cost = cost_X * X + cost_Y * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];