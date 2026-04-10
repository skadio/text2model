% Resource allocation between Project X and Project Y
% Minimize total cost subject to constraints

int: total_limit = 2000;
int: max_x = 1500;
int: max_y = 1000;

int: cost_x = 5;
int: cost_y = 3;

int: c1_min_diff = 500;   % 2X - Y >= 500
int: c2_max_diff = 1000;  % X - 2Y <= 1000

var 0..max_x: X;
var 0..max_y: Y;

constraint X + Y <= total_limit;
constraint 2*X - Y >= c1_min_diff;
constraint X - 2*Y <= c2_max_diff;

var int: total_cost = cost_x * X + cost_y * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];