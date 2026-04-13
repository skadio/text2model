% Parameters (with values embedded)
int: total_hours_max = 40;
int: min_effort = 20;                 % 2*X + Y >= 20
int: max_diff = 10;                   % |X - Y| <= 10
int: cost_x = 8;
int: cost_y = 10;
int: x_max = 25;
int: y_max = 15;

% Variables
var 0..x_max: X;
var 0..y_max: Y;
var int: total_cost;

% Constraints
constraint X + Y <= total_hours_max;
constraint 2 * X + Y >= min_effort;
constraint abs(X - Y) <= max_diff;

constraint total_cost = cost_x * X + cost_y * Y;

% Objective
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];