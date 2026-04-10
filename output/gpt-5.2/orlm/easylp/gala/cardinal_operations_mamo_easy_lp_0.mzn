% Resource allocation between projects X and Y
% Minimize total cost subject to budget and operational constraints.

int: total_max = 1000;
int: x_max = 700;
int: y_max = 500;

int: min_excess = 200;      % X must exceed Y by at least this much
int: cost_x = 50;           % $ per unit of X
int: cost_y = 30;           % $ per unit of Y

var 0..x_max: x;            % units allocated to project X
var 0..y_max: y;            % units allocated to project Y

constraint x + y <= total_max;
constraint x - y >= min_excess;

var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n"
];