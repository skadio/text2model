% Resource allocation MILP (integer)
% All data embedded as requested.

int: a_log_X = 10;
int: a_log_Y = 20;
int: b_log = 3000;

int: a_str_X = 3;
int: a_str_Y = 5;
int: b_str = 500;

int: max_diff = 1000;

int: cost_X = 10000; % dollars per unit X
int: cost_Y = 20000; % dollars per unit Y

% Upper bounds implied by logistics constraint (nonnegative integers)
int: ub_X = b_log div a_log_X; % 300
int: ub_Y = b_log div a_log_Y; % 150

var 0..ub_X: X;
var 0..ub_Y: Y;

constraint a_log_X * X + a_log_Y * Y <= b_log;
constraint a_str_X * X + a_str_Y * Y >= b_str;

constraint X - Y <= max_diff;
constraint Y - X <= max_diff;

var int: total_cost = cost_X * X + cost_Y * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];